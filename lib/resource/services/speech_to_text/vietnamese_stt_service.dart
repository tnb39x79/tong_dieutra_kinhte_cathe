import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
 
import 'stt_enums.dart';

/// Vietnamese Speech-to-Text Service using Batch Processing
///
/// This service provides offline Vietnamese speech recognition using a batch
/// processing approach suitable for non-streaming sherpa-onnx models.
/// Audio is recorded to a temporary file and then processed after recording stops.
class VietnameseSTTService extends GetxService {
  static const String _logTag = 'VietnameseSTTService';
  static const int _sampleRate = 16000;

  // Core components
  OfflineRecognizer? _recognizer;
  AudioRecorder? _audioRecorder;

  // Audio file management
  String? _currentRecordingPath;
  Directory? _tempDirectory;
  final List<String> _tempFiles = [];

  // State management
  final Rx<STTServiceState> _state = STTServiceState.uninitialized.obs;
  final RxString _currentText = ''.obs;
  final RxString _lastText = ''.obs;
  final RxString _error = ''.obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isRecording = false.obs;

  bool _isDisposing = false;

  // Getters
  STTServiceState get state => _state.value;

  String get currentText => _currentText.value;

  String get lastText => _lastText.value;

  String get error => _error.value;

  bool get isInitialized => _isInitialized.value;

  bool get isRecording => _isRecording.value;

  // Reactive getters
  Rx<STTServiceState> get stateRx => _state;

  RxString get currentTextRx => _currentText;

  RxString get lastTextRx => _lastText;

  RxString get errorRx => _error;

  RxBool get isRecordingRx => _isRecording;

  /// Get the current Documents directory path (iOS-safe)
  Future<String> _getDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Convert relative path to absolute path using current Documents directory
  Future<String> _getAbsolutePath(String relativePath) async {
    // If already absolute, return as-is
    if (relativePath.startsWith('/')) {
      return relativePath;
    }

    final documentsPath = await _getDocumentsDirectoryPath();
    return '$documentsPath/$relativePath';
  }

  /// Get absolute path from stored relative path (iOS-safe)
  Future<String?> _getStoredAbsolutePath(String prefKey) async {
    String? relativePath;

    switch (prefKey) {
      case 'dataModelSTTEncoderPath':
        relativePath = AppPref.dataModelSTTEncoderPath;
        break;
      case 'dataModelSTTDecoderPath':
        relativePath = AppPref.dataModelSTTDecoderPath;
        break;
      case 'dataModelSTTJoinerPath':
        relativePath = AppPref.dataModelSTTJoinerPath;
        break;
      case 'dataModelSTTTokensPath':
        relativePath = AppPref.dataModelSTTTokensPath;
        break;
    }

    if (relativePath == null || relativePath.isEmpty) {
      return null;
    }

    return await _getAbsolutePath(relativePath);
  }

  @override
  void onInit() {
    log('VietnameseSTTService initialized', name: _logTag);
    initialize();
    super.onInit();
  }

  /// Check if model configuration files exist on device (iOS-safe with relative paths)
  /// Returns a map with file paths and their existence status
  Future<Map<String, dynamic>> checkModelConfiguration() async {
    try {
      log('Checking model configuration files (iOS-safe)', name: _logTag);

      final result = <String, dynamic>{
        'isComplete': false,
        'files': <String, bool>{},
        'missingFiles': <String>[],
        'paths': <String, String>{},
        'absolutePaths': <String, String>{},
      };

      // Get absolute paths from stored relative paths (iOS-safe)
      final encoderAbsolutePath = await _getStoredAbsolutePath('dataModelSTTEncoderPath');
      final decoderAbsolutePath = await _getStoredAbsolutePath('dataModelSTTDecoderPath');
      final joinerAbsolutePath = await _getStoredAbsolutePath('dataModelSTTJoinerPath');
      final tokensAbsolutePath = await _getStoredAbsolutePath('dataModelSTTTokensPath');

      // Check each file
      final filesToCheck = {
        'encoder': encoderAbsolutePath,
        'decoder': decoderAbsolutePath,
        'joiner': joinerAbsolutePath,
        'tokens': tokensAbsolutePath,
      };

      // Also store relative paths for reference
      final relativePaths = {
        'encoder': AppPref.dataModelSTTEncoderPath,
        'decoder': AppPref.dataModelSTTDecoderPath,
        'joiner': AppPref.dataModelSTTJoinerPath,
        'tokens': AppPref.dataModelSTTTokensPath,
      };

      bool allFilesExist = true;

      for (final entry in filesToCheck.entries) {
        final fileName = entry.key;
        final absolutePath = entry.value;
        final relativePath = relativePaths[fileName] ?? '';

        result['paths'][fileName] = relativePath; // Store relative path
        result['absolutePaths'][fileName] = absolutePath ?? ''; // Store absolute path

        if (absolutePath == null || absolutePath.isEmpty) {
          result['files'][fileName] = false;
          result['missingFiles'].add(fileName);
          allFilesExist = false;
          log('$fileName absolute path is null or empty (relative: $relativePath)', name: _logTag);
        } else {
          final fileExists = await File(absolutePath).exists();
          result['files'][fileName] = fileExists;

          if (!fileExists) {
            result['missingFiles'].add(fileName);
            allFilesExist = false;
            log('$fileName file not found at: $absolutePath (relative: $relativePath)', name: _logTag);
          } else {
            // Check file size to ensure it's not corrupted
            final fileSize = await File(absolutePath).length();
            log('$fileName found: $absolutePath ($fileSize bytes)',
                name: _logTag);
          }
        }
      }

      result['isComplete'] = allFilesExist;

      if (allFilesExist) {
        log('All model configuration files are available',
            name: _logTag);
      } else {
        log('Missing model files: ${result['missingFiles'].join(', ')}',
            name: _logTag);
      }

      return result;
    } catch (e, stackTrace) {
      log('Error checking model configuration: $e', name: _logTag);
      log('Stack trace: $stackTrace', name: _logTag);
      return {
        'isComplete': false,
        'error': e.toString(),
        'files': <String, bool>{},
        'missingFiles': <String>[],
        'paths': <String, String>{},
      };
    }
  }

  /// Load model in background thread to prevent UI blocking
  /// Returns true if model loaded successfully, false otherwise
  Future<bool> loadModelInBackground() async {
    try {
      log('Starting model loading in background thread', name: _logTag);

      // First check if model configuration is complete
      final configCheck = await checkModelConfiguration();
      if (!configCheck['isComplete']) {
        final missingFiles = configCheck['missingFiles'] as List<String>;
        throw Exception(
            'Model configuration incomplete. Missing files: ${missingFiles.join(', ')}');
      }

      // Prepare absolute model paths
      final modelPaths = {
        'encoder': await _getStoredAbsolutePath('dataModelSTTEncoderPath') ?? '',
        'decoder': await _getStoredAbsolutePath('dataModelSTTDecoderPath') ?? '',
        'joiner': await _getStoredAbsolutePath('dataModelSTTJoinerPath') ?? '',
        'tokens': await _getStoredAbsolutePath('dataModelSTTTokensPath') ?? '',
      };

      // Validate that all paths are available
      for (final entry in modelPaths.entries) {
        if (entry.value.isEmpty) {
          throw Exception('${entry.key} path is empty after resolution');
        }
      }

      log('Using resolved absolute paths for background loading:', name: _logTag);
      log('  Encoder: ${modelPaths['encoder']}', name: _logTag);
      log('  Decoder: ${modelPaths['decoder']}', name: _logTag);
      log('  Joiner: ${modelPaths['joiner']}', name: _logTag);
      log('  Tokens: ${modelPaths['tokens']}', name: _logTag);

      // Use compute to run model loading in background thread with timeout
      log('Creating recognizer in background thread...', name: _logTag);

      // Add timeout to prevent indefinite hanging
      final recognizer = await compute(_createRecognizerInBackground, modelPaths)
          .timeout(
            const Duration(minutes: 1),
            onTimeout: () {
              log('Model loading timeout after 1 minutes', name: _logTag);
              return null;
            },
          );

      if (recognizer != null) {
        _recognizer = recognizer;
        log('Model loaded successfully in background thread', name: _logTag);
        return true;
      } else {
        log('Failed to create recognizer in background thread', name: _logTag);
        return false;
      }
    } catch (e, stackTrace) {
      log('Error in background model loading: $e', name: _logTag);
      log('Stack trace: $stackTrace', name: _logTag);
      return false;
    }
  }

  /// Static method for compute to create recognizer in background thread
  static OfflineRecognizer? _createRecognizerInBackground(Map<String, String> modelPaths) {
    try {
      print('Background thread: Starting model loading...');

      // Validate all model files exist and are readable
      for (final entry in modelPaths.entries) {
        final fileName = entry.key;
        final filePath = entry.value;

        print('Background thread: Checking $fileName at $filePath');

        final file = File(filePath);
        if (!file.existsSync()) {
          throw Exception('Model file not found: $fileName at $filePath');
        }

        final fileSize = file.lengthSync();
        if (fileSize == 0) {
          throw Exception('Model file is empty: $fileName at $filePath');
        }

        print('Background thread: $fileName validated ($fileSize bytes)');
      }

      print('Background thread: Initializing sherpa-onnx bindings...');
      // Initialize sherpa-onnx bindings in this thread
      initBindings();

      print('Background thread: Creating model configuration...');
      // Create model configuration
      final modelConfig = OfflineModelConfig(
        transducer: OfflineTransducerModelConfig(
          encoder: modelPaths['encoder']!,
          decoder: modelPaths['decoder']!,
          joiner: modelPaths['joiner']!,
        ),
        tokens: modelPaths['tokens']!,
        debug: false,
        numThreads: 2, // Limit threads to prevent resource exhaustion
      );

      print('Background thread: Creating recognizer configuration...');
      // Create recognizer configuration
      final config = OfflineRecognizerConfig(
        model: modelConfig,
      );

      print('Background thread: Creating OfflineRecognizer...');
      final recognizer = OfflineRecognizer(config);

      print('Background thread: OfflineRecognizer created successfully');
      return recognizer;
    } catch (e, stackTrace) {
      print('Background thread: Error creating recognizer: $e');
      print('Background thread: Stack trace: $stackTrace');
      return null;
    }
  }



  /// Initialize the service with enhanced model checking and loading
  Future<void> initialize() async {
    if (_isDisposing || _isInitialized.value) return;

    _updateState(STTServiceState.initializing);
    _error.value = '';

    try {
      log(
          'Initializing Vietnamese STT Service (Enhanced with Background Thread Loading)',
          name: _logTag);

      // Initialize sherpa-onnx bindings (only once)
      initBindings();

      // Initialize audio recorder
      _audioRecorder = AudioRecorder();

      // Setup temporary directory for audio files
      await _setupTempDirectory();

      // Check model configuration first
      final configCheck = await checkModelConfiguration();
      if (!configCheck['isComplete']) {
        final missingFiles = configCheck['missingFiles'] as List<String>;
        final errorMsg =
            'Model configuration incomplete. Missing files: ${missingFiles.join(', ')}. Please download the AI models first.';
        _error.value = errorMsg;
        _updateState(STTServiceState.error);
        return;
      }

      // Load speech model using background thread for processing
      log('Loading model in background thread...', name: _logTag);
      bool modelLoaded = await loadModelInBackground();

      if (!modelLoaded) {
        const errorMsg =
            'Failed to load speech model using background thread. The model files may be corrupted or incompatible.';
        _error.value = errorMsg;
        _updateState(STTServiceState.error);
        return;
      }

      _isInitialized.value = true;
      _updateState(STTServiceState.ready);

      log('STT Service initialized successfully with background thread loading',
          name: _logTag);
    } catch (e, stackTrace) {
      _error.value = e.toString();
      _updateState(STTServiceState.error);
      log('STT initialization failed: $e', name: _logTag);
      log('Stack trace: $stackTrace', name: _logTag);
    }
  }

  /// Quick initialization check without full model loading
  /// Returns true if service can be initialized, false if models are missing
  Future<bool> canInitialize() async {
    try {
      final configCheck = await checkModelConfiguration();
      return configCheck['isComplete'] as bool;
    } catch (e) {
      log('Error checking if service can initialize: $e', name: _logTag);
      return false;
    }
  }

  /// Setup temporary directory for audio file caching
  Future<void> _setupTempDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _tempDirectory = Directory(path.join(appDir.path, 'stt_temp'));

      if (!await _tempDirectory!.exists()) {
        await _tempDirectory!.create(recursive: true);
      }

      log('Temp directory setup: ${_tempDirectory!.path}', name: _logTag);
    } catch (e) {
      throw Exception('Failed to setup temp directory: $e');
    }
  }

  /// Start recording audio to a temporary file
  Future<void> startRecording() async {
    // Check permissions
    final hasPermission = await _audioRecorder!.hasPermission();
    if (!hasPermission) {
      throw Exception('Microphone permission denied');
    }
    if (!_state.value.canStartRecording) {
      throw Exception(
          'Cannot start recording in current state: ${_state.value}');
    }

    try {
      log('Starting audio recording to file', name: _logTag);

      // Generate unique filename for this recording
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'recording_$timestamp.wav';
      _currentRecordingPath = path.join(_tempDirectory!.path, filename);

      // Configure audio recording to file
      final config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: _sampleRate,
        numChannels: 1,
        bitRate: 128000,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      );

      // Start recording to file
      await _audioRecorder!.start(config, path: _currentRecordingPath!);

      _updateState(STTServiceState.recording);
      _isRecording.value = true;
      _currentText.value = 'Recording...';
      _error.value = '';

      // Track temp file for cleanup
      _tempFiles.add(_currentRecordingPath!);

      log('Recording started to file: $_currentRecordingPath',
          name: _logTag);
    } catch (e) {
      _handleError('Failed to start recording: $e');
      rethrow;
    }
  }

  /// Stop recording and process the audio file
  Future<String> stopRecording() async {
    if (!_state.value.canStopRecording) {
      throw Exception(
          'Cannot stop recording in current state: ${_state.value}');
    }

    try {
      log('Stopping audio recording and processing file', name: _logTag);

      _updateState(STTServiceState.processing);
      _currentText.value = 'Processing...';

      // Stop audio recording
      await _audioRecorder?.stop();
      _isRecording.value = false;

      if (_currentRecordingPath == null) {
        throw Exception('No recording file path available');
      }

      // Verify the recorded file exists and has content
      final recordedFile = File(_currentRecordingPath!);
      if (!await recordedFile.exists()) {
        throw Exception('Recorded file does not exist: $_currentRecordingPath');
      }

      final fileSize = await recordedFile.length();
      if (fileSize == 0) {
        throw Exception('Recorded file is empty');
      }

      log(
          'Processing audio file: $_currentRecordingPath ($fileSize bytes)',
          name: _logTag);

      // Process the audio file through sherpa-onnx
      final result = await _processAudioFile(_currentRecordingPath!);

      _lastText.value = result;
      _currentText.value = '';
      _updateState(STTServiceState.ready);

      log('Recording processed. Result: "$result"', name: _logTag);

      return result;
    } catch (e) {
      _handleError('Failed to stop recording and process: $e');
      rethrow;
    }
  }

  /// Toggle recording (start if ready, stop if recording)
  Future<String> toggleRecording() async {
    if (_state.value.canStartRecording) {
      await startRecording();
      return '';
    } else if (_state.value.canStopRecording) {
      return await stopRecording();
    } else {
      throw Exception(
          'Cannot toggle recording in current state: ${_state.value}');
    }
  }

  /// Process an audio file through sherpa-onnx for batch recognition
  Future<String> _processAudioFile(String audioFilePath) async {
    try {
      log('Processing audio file: $audioFilePath', name: _logTag);

      if (_recognizer == null) {
        throw Exception('Recognizer not initialized');
      }

      // Read audio file and convert to samples
      final audioFile = File(audioFilePath);
      final audioBytes = await audioFile.readAsBytes();

      // Convert audio file to Float32List samples
      final samples = await _convertAudioFileToSamples(audioBytes);

      if (samples.isEmpty) {
        log('No audio samples extracted from file', name: _logTag);
        return '';
      }

      log('Extracted ${samples.length} audio samples', name: _logTag);

      // Create a stream for batch processing
      final stream = _recognizer!.createStream();

      try {
        // Feed all audio data to the stream at once
        stream.acceptWaveform(samples: samples, sampleRate: _sampleRate);

        // Decode the audio
        _recognizer!.decode(stream);

        // Get the final result
        final result = _recognizer!.getResult(stream);
        final recognizedText = result.text.trim();

        log('Recognition result: "$recognizedText"', name: _logTag);
        return recognizedText;
      } finally {
        // Always free the stream
        stream.free();
      }
    } catch (e, stackTrace) {
      log('Error processing audio file: $e', name: _logTag);
      log('Stack trace: $stackTrace', name: _logTag);
      rethrow;
    }
  }

  /// Convert audio file bytes to Float32List samples
  Future<Float32List> _convertAudioFileToSamples(Uint8List audioBytes) async {
    try {
      // For WAV files, we need to skip the header and extract PCM data
      // This is a simplified approach - in production you might want to use
      // a proper audio library for more robust WAV parsing

      if (audioBytes.length < 44) {
        throw Exception('Audio file too small to contain valid WAV header');
      }

      // Skip WAV header (44 bytes) and get PCM data
      final pcmData = audioBytes.sublist(44);

      // Convert 16-bit PCM to Float32List
      final samples = Float32List(pcmData.length ~/ 2);
      for (int i = 0; i < samples.length; i++) {
        final sample16 = (pcmData[i * 2 + 1] << 8) | pcmData[i * 2];
        // Convert from signed 16-bit to float32 (-1.0 to 1.0)
        samples[i] = sample16.toSigned(16) / 32768.0;
      }

      return samples;
    } catch (e) {
      log('Error converting audio bytes to samples: $e', name: _logTag);
      return Float32List(0);
    }
  }

  /// Reset service to clean state
  Future<void> reset() async {
    try {
      log('Resetting service', name: _logTag);

      // Stop recording if active
      if (_state.value == STTServiceState.recording) {
        await stopRecording().catchError((e) => '$e');
      }

      // Cleanup resources
      await _cleanup();

      // Reset state
      _updateState(STTServiceState.uninitialized);
      _isInitialized.value = false;
      _isRecording.value = false;
      _error.value = '';
      _currentText.value = '';
      _currentRecordingPath = null;

      log('Service reset completed', name: _logTag);
    } catch (e) {
      log('Reset failed: $e', name: _logTag);
    }
  }

  /// Clean up temporary audio files
  Future<void> cleanupTempFiles() async {
    try {
      log('Cleaning up ${_tempFiles.length} temporary files',
          name: _logTag);

      for (final filePath in _tempFiles) {
        try {
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
            log('Deleted temp file: $filePath', name: _logTag);
          }
        } catch (e) {
          log('Failed to delete temp file $filePath: $e', name: _logTag);
        }
      }

      _tempFiles.clear();
    } catch (e) {
      log('Error during temp file cleanup: $e', name: _logTag);
    }
  }

  /// Update service state
  void _updateState(STTServiceState newState) {
    final oldState = _state.value;
    _state.value = newState;
    log('State: $oldState -> $newState', name: _logTag);
  }

  /// Handle errors
  void _handleError(String errorMessage) {
    _error.value = errorMessage;
    _updateState(STTServiceState.error);
    log(errorMessage, name: _logTag);
  }

  /// Cleanup resources
  Future<void> _cleanup() async {
    try {
      // Stop recording if active
      if (_isRecording.value) {
        await _audioRecorder?.stop().catchError((e) => null);
        _isRecording.value = false;
      }

      // Dispose audio recorder
      _audioRecorder?.dispose();
      _audioRecorder = null;

      // Free recognizer resources properly
      if (_recognizer != null) {
        try {
          _recognizer!.free(); // This is important for memory cleanup
        } catch (e) {
          log('Error freeing recognizer: $e', name: _logTag);
        }
        _recognizer = null;
      }

      // Clean up temporary files
      await cleanupTempFiles();

      _currentRecordingPath = null;
    } catch (e) {
      log('Cleanup error: $e', name: _logTag);
    }
  }

  @override
  void onClose() {
    log('Service disposing', name: _logTag);
    _isDisposing = true;
    _cleanup();
    super.onClose();
  }
}
