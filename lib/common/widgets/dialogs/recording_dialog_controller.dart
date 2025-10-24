import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_widget.dart';
import 'package:gov_statistics_investigation_economic/resource/services/speech_to_text/vietnamese_stt_service.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart'; 

/// Controller for Recording Dialog
///
/// Manages the state and business logic for the recording dialog widget.
/// Handles STT service integration, recording lifecycle, and UI state management.
class RecordingDialogController extends GetxController {
  static const String _logTag = 'RecordingDialogController';

  // Dependencies
  late VietnameseSTTService _sttService;

  // Timer for recording duration
  Timer? _timer;
  int _recordingDuration = 0;

  // State management
  final RxString _statusText = ''.obs;
  final RxString _errorText = ''.obs;
  final RxBool _isInitializing = false.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isProcessing = false.obs;
  final RxBool _isCanceling = false.obs;
  final RxInt _recordingTime = 0.obs;
  final RxBool _isCheckingModel = false.obs;
  final RxBool _isLoadingModel = false.obs;
  final RxString _initializationProgress = ''.obs;

  // Configuration
  final String _hint = 'Nhấn để bắt đầu ghi âm...';

  // Getters
  String get statusText => _statusText.value;

  String get errorText => _errorText.value;

  bool get isInitializing => _isInitializing.value;

  bool get isRecording => _isRecording.value;

  bool get isProcessing => _isProcessing.value;

  bool get isCanceling => _isCanceling.value;

  int get recordingTime => _recordingTime.value;

  bool get isCheckingModel => _isCheckingModel.value;

  bool get isLoadingModel => _isLoadingModel.value;

  String get initializationProgress => _initializationProgress.value;

  bool get canRecord =>
      _sttService.state.isOperational &&
      !_isInitializing.value &&
      !_isCheckingModel.value &&
      !_isLoadingModel.value;

  // Reactive getters
  RxString get statusTextRx => _statusText;

  RxString get errorTextRx => _errorText;

  RxBool get isInitializingRx => _isInitializing;

  RxBool get isRecordingRx => _isRecording;

  RxBool get isProcessingRx => _isProcessing;

  RxBool get isCancelingRx => _isCanceling;

  RxInt get recordingTimeRx => _recordingTime;

  RxBool get isCheckingModelRx => _isCheckingModel;

  RxBool get isLoadingModelRx => _isLoadingModel;

  RxString get initializationProgressRx => _initializationProgress;

  /// Toggle recording with enhanced model validation and initialization (Non-blocking)
  Future<String?> toggleRecording() async {
    try {
      // If currently recording, stop it
      if (_sttService.state.canStopRecording) {
        return await _stopRecording();
      }

      // If ready to start recording, check model first
      if (_sttService.state.canStartRecording) {
        // Check if model validation and initialization is needed
        final modelValidated = await _validateAndInitializeModel();
        if (!modelValidated) {
          return null; // Model validation failed, don't proceed
        }

        // Start recording in a non-blocking way
        _startRecordingAsync();
        return null;
      }

      // If service is not ready, try to initialize
      if (!_sttService.isInitialized) {
        final initialized = await _validateAndInitializeModel();
        if (initialized) {
          _startRecordingAsync();
        }
        return null;
      }

      throw Exception(
          'Cannot toggle recording in current state: ${_sttService.state}');
    } catch (e, stackTrace) {
      _errorText.value = 'Lỗi ghi âm: ${e.toString()}';
      log('Recording toggle error: $e $stackTrace', name: _logTag);
      return null;
    }
  }

  /// Validate model existence and initialize if needed
  /// Returns true if model is ready for recording, false otherwise
  Future<bool> _validateAndInitializeModel() async {
    try {
      log('Starting model validation and initialization', name: _logTag);

      // Step 1: Check if model configuration exists
      _isCheckingModel.value = true;
      _statusText.value = 'Đang kiểm tra mô hình AI...';
      _errorText.value = '';

      final configCheck = await _sttService.checkModelConfiguration();
      _isCheckingModel.value = false;

      // Step 2: Handle missing model files
      if (!configCheck['isComplete']) {
        final missingFiles = configCheck['missingFiles'] as List<String>;
        log('Model files missing: ${missingFiles.join(', ')}',
            name: _logTag);

        await _showModelNotFoundDialog();
        return false;
      }

      log('Model configuration is complete', name: _logTag);

      // Step 3: Check if service is already initialized
      if (_sttService.isInitialized) {
        log('STT service already initialized', name: _logTag);
        _statusText.value = _hint;
        return true;
      }

      // Step 4: Initialize the service with isolate-based loading
      return await _initializeModelWithProgress();
    } catch (e, stackTrace) {
      _isCheckingModel.value = false;
      _isLoadingModel.value = false;
      _errorText.value = 'Lỗi kiểm tra mô hình: ${e.toString()}';
      log('Model validation error: $e $stackTrace', name: _logTag);
      return false;
    }
  }

  /// Initialize model with progress indication (non-blocking UI)
  Future<bool> _initializeModelWithProgress() async {
    try {
      _isLoadingModel.value = true;
      _initializationProgress.value = 'Đang chuẩn bị tải mô hình...';
      _statusText.value = 'Đang tải mô hình AI...';

      log('Starting model initialization with isolate loading',
          name: _logTag);

      // Create a completer to handle the async result
      final completer = Completer<bool>();

      // Initialize the model in a microtask to avoid blocking UI
      Future.microtask(() async {
        try {
          // Update progress
          _initializationProgress.value = 'Đang tải mô hình AI...';

          // Use the enhanced initialize method which includes isolate loading
          await _sttService.initialize();

          _isLoadingModel.value = false;
          _initializationProgress.value = '';
          _statusText.value = _hint;

          log('Model initialization completed successfully', name: _logTag);
          completer.complete(true);
        } catch (e, stackTrace) {
          _isLoadingModel.value = false;
          _initializationProgress.value = '';

          // Provide user-friendly error messages
          String userMessage;
          if (e.toString().contains('Model configuration incomplete')) {
            userMessage =
                'Mô hình AI chưa được tải xuống đầy đủ. Vui lòng tải lại mô hình.';
          } else if (e.toString().contains('Microphone permission denied')) {
            userMessage = 'Cần cấp quyền microphone để sử dụng tính năng ghi âm.';
          } else if (e.toString().contains('Failed to load speech model')) {
            userMessage =
                'Không thể tải mô hình AI. Mô hình có thể bị lỗi hoặc không tương thích.';
          } else {
            userMessage = 'Lỗi khởi tạo mô hình AI: ${e.toString()}';
          }

          _errorText.value = userMessage;
          _statusText.value = 'Lỗi khởi tạo';

          log('Model initialization failed: $e $stackTrace', name: _logTag);
          completer.complete(false);
        }
      });

      return await completer.future;
    } catch (e, stackTrace) {
      _isLoadingModel.value = false;
      _initializationProgress.value = '';
      _errorText.value = 'Lỗi khởi tạo mô hình AI: ${e.toString()}';
      _statusText.value = 'Lỗi khởi tạo';
      log('Model initialization failed: $e $stackTrace', name: _logTag);
      return false;
    }
  }

  /// Show dialog when model is not found
  Future<void> _showModelNotFoundDialog() async {
    await Get.dialog(
      DialogWidget(
        title: 'Mô hình AI chưa có sẵn',
        content:
            'Mô hình AI Nhận dạng giọng nói chưa có trên thiết bị của bạn. Vui lòng tải xuống ở màn hình \'Cập nhật dữ liệu AI\' để sử dụng tính năng chuyển đổi giọng nói thành văn bản.',
        confirmText: 'Đi tới tải xuống',
        onPressedPositive: () {
          Get.back(); // Close dialog
          Get.back(); // Close recording dialog
          Get.toNamed(AppRoutes.downloadModelAI_V2); // Navigate to AI download screen
        },
        onPressedNegative: () {
          Get.back(); // Close dialog only
        },
      ),
      barrierDismissible: false,
    );
  }

  /// Start recording asynchronously (non-blocking UI)
  void _startRecordingAsync() {
    // Update UI immediately to show recording is starting
    _statusText.value = 'Đang bắt đầu ghi âm...';
    _errorText.value = '';
    _isRecording.value = true;

    // Perform the actual recording start in a microtask to avoid blocking UI
    Future.microtask(() async {
      try {
        log('Starting recording asynchronously', name: _logTag);

        // Start recording (this might be blocking, so we do it in microtask)
        await _sttService.startRecording();

        // Update status and start timer
        _statusText.value = 'Đang ghi âm...';
        _startTimer();

        log('Recording started successfully', name: _logTag);
      } catch (e, stackTrace) {
        _isRecording.value = false;
        _errorText.value = 'Lỗi bắt đầu ghi âm: ${e.toString()}';
        log('Failed to start recording: $e $stackTrace', name: _logTag);
      }
    });
  }

  /// Start recording (synchronous version for internal use or future features)
  // ignore: unused_element
  Future<void> _startRecording() async {
    try {
      log('Starting recording', name: _logTag);

      // Update UI immediately
      _statusText.value = 'Đang bắt đầu ghi âm...';
      _errorText.value = '';
      _isRecording.value = true;

      // Start recording
      await _sttService.startRecording();

      // Update status and start timer
      _statusText.value = 'Đang ghi âm...';
      _startTimer();

      log('Recording started successfully', name: _logTag);
    } catch (e, stackTrace) {
      _isRecording.value = false;
      _errorText.value = 'Lỗi bắt đầu ghi âm: ${e.toString()}';
      log('Failed to start recording: $e $stackTrace', name: _logTag);
      rethrow;
    }
  }

  /// Stop recording and process audio (non-blocking UI)
  Future<String> _stopRecording() async {
    try {
      log('Stopping recording', name: _logTag);

      // Update UI immediately
      _statusText.value = 'Đang dừng ghi âm...';
      _isRecording.value = false;
      _isProcessing.value = true;

      // Stop timer
      _stopTimer();

      // Create a completer to handle the async result
      final completer = Completer<String>();

      // Process the recording in a microtask to avoid blocking UI
      Future.microtask(() async {
        try {
          // Update status to show processing
          _statusText.value = 'Đang xử lý...';

          // Stop recording and get result (this might be CPU intensive)
          final recognizedText = await _sttService.stopRecording();

          _isProcessing.value = false;

          if (recognizedText.isNotEmpty) {
            _statusText.value = 'Hoàn thành!';
            log('Recording processed successfully: "$recognizedText"',
                name: _logTag);
            completer.complete(recognizedText);
          } else {
            _statusText.value = 'Không nhận diện được giọng nói';
            _errorText.value = 'Vui lòng thử lại';
            log('No text recognized from recording', name: _logTag);
            completer.complete('');
          }
        } catch (e, stackTrace) {
          _isRecording.value = false;
          _isProcessing.value = false;
          _statusText.value = 'Lỗi xử lý';
          _errorText.value = e.toString();
          log('Failed to stop recording and process: $e $stackTrace',
              name: _logTag);
          completer.completeError(e);
        }
      });

      return await completer.future;
    } catch (e, stackTrace) {
      _isRecording.value = false;
      _isProcessing.value = false;
      _statusText.value = 'Lỗi xử lý';
      _errorText.value = e.toString();
      log('Failed to stop recording and process: $e $stackTrace',
          name: _logTag);
      rethrow;
    }
  }

  /// Start the recording timer
  void _startTimer() {
    _recordingDuration = 0;
    _recordingTime.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration++;
      _recordingTime.value = _recordingDuration;
    });
  }

  /// Stop the recording timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Format duration for display (MM:SS)
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Get the appropriate label for the record button
  String getRecordButtonLabel() {
    if (_isProcessing.value) {
      return 'Đang xử lý...';
    } else if (_isRecording.value) {
      return 'Dừng ghi âm';
    } else {
      return 'Bắt đầu ghi âm';
    }
  }

  /// Cancel recording and clean up resources
  Future<void> cancelRecording() async {
    try {
      log('Canceling recording', name: _logTag);

      _isCanceling.value = true;

      // Stop timer immediately
      _stopTimer();

      // If currently recording, stop the STT service
      if (_isRecording.value || _isProcessing.value) {
        _statusText.value = 'Đang hủy ghi âm...';

        try {
          // Stop recording if active
          if (_sttService.state.canStopRecording) {
            await _sttService.stopRecording();
          }
        } catch (e) {
          log('Error stopping recording during cancel: $e', name: _logTag);
          // Continue with cleanup even if stop fails
        }
      }

      // Reset all state
      reset();

      log('Recording canceled successfully', name: _logTag);
    } catch (e, stackTrace) {
      log('Error during cancel recording: $e $stackTrace', name: _logTag);
      // Force reset state even if there's an error
      reset();
    } finally {
      _isCanceling.value = false;
    }
  }

  /// Reset the controller state
  void reset() {
    _stopTimer();
    _statusText.value = _hint;
    _errorText.value = '';
    _isRecording.value = false;
    _isProcessing.value = false;
    _isCanceling.value = false;
    _recordingTime.value = 0;
    _recordingDuration = 0;
    _isCheckingModel.value = false;
    _isLoadingModel.value = false;
    _initializationProgress.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  /// Initialize the Vietnamese STT service
  void _initializeService() {
    try {
      // Try to get the service from dependency injection
      if (Get.isRegistered<VietnameseSTTService>()) {
        _sttService = Get.find<VietnameseSTTService>();
        log('STT service found and initialized successfully', name: _logTag);
        _statusText.value = _hint;
      } else {
        // Service not registered yet, try to register it
        log('STT service not registered, attempting to create instance', name: _logTag);
        _sttService = VietnameseSTTService();
        Get.put(_sttService, permanent: true);
        log('STT service created and registered successfully', name: _logTag);
        _statusText.value = _hint;
      }
    } catch (e) {
      log('Failed to initialize STT service: $e', name: _logTag);
      _errorText.value = 'Lỗi khởi tạo dịch vụ STT: ${e.toString()}';
      _statusText.value = 'Lỗi khởi tạo dịch vụ';
    }
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
