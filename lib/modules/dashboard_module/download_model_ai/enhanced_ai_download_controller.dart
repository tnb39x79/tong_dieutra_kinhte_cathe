import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/download_task/download_task_service.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/input_data/input_data_repository.dart';
import 'package:gov_statistics_investigation_economic/resource/services/network_service/network_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/common/common.dart';
import '/modules/modules.dart';

/// Model types enum for AI downloads
enum ModelType { suggestions, speechToText }

/// File types enum for download handling
enum FileType { suggestionOnnx, sttZip, genericOnnx, genericZip, unknown }

/// Enhanced AI Download Controller
///
/// Supports downloading multiple AI model types with individual progress tracking:
/// - AI Mã Ngành (suggestions) - for industry code suggestions
/// - AI Nhận Dạng Giọng Nói (speech to text) - for Vietnamese STT functionality
class EnhancedAiDownloadController extends BaseController {
  final InputDataRepository dataRepository;

  EnhancedAiDownloadController(this.dataRepository);

  NetworkService networkServiceStatus = Get.find();

  /// Get network connection status (reactive)
  @override
  bool get isConnected => networkServiceStatus.isConnected;

  // Individual model states
  final Map<ModelType, RxBool> _isDownloading = {
    ModelType.suggestions: false.obs,
    ModelType.speechToText: false.obs,
  };

  final Map<ModelType, RxBool> _isDownloaded = {
    ModelType.suggestions: false.obs,
    ModelType.speechToText: false.obs,
  };

  final Map<ModelType, RxDouble> _downloadProgress = {
    ModelType.suggestions: 0.0.obs,
    ModelType.speechToText: 0.0.obs,
  };

  final Map<ModelType, RxString> _downloadStatus = {
    ModelType.suggestions: ''.obs,
    ModelType.speechToText: ''.obs,
  };

  // Store active download task references for cancellation
  final Map<ModelType, DownloadTaskService?> _activeDownloadTasks = {
    ModelType.suggestions: null,
    ModelType.speechToText: null,
  };

  // Store cache file paths for cleanup
  final Map<ModelType, String?> _cacheFilePaths = {
    ModelType.suggestions: null,
    ModelType.speechToText: null,
  };

  // Model information
  final Map<ModelType, Map<String, dynamic>> _modelInfo = {
    ModelType.suggestions: {
      'title': 'AI Mã Ngành',
      'description': 'Mô hình AI hỗ trợ gợi ý mã ngành nghề kinh doanh',
      'icon': Icons.lightbulb_outline,
      'size': '~130MB',
      'files': ['suggestions.onnx'],
    },
    ModelType.speechToText: {
      'title': 'AI Nhận Dạng Giọng Nói',
      'description': 'Mô hình AI chuyển đổi giọng nói tiếng Việt thành văn bản',
      'icon': Icons.mic,
      'size': '~240MB',
      'files': [
        'vietnamese_encoder.onnx',
        'vietnamese_decoder.onnx',
        'vietnamese_joiner.onnx',
        'vietnamese_tokens.txt'
      ],
    },
  };

  final Map<ModelType, String> _modelDownloadUrls = {
    ModelType.suggestions: '',
    ModelType.speechToText: '',
  };

  @override
  void onInit() async {
    super.onInit();

    // Listen to network changes for real-time updates
    ever(networkServiceStatus.connectionTypeObservable,
        (Network connectionType) {
      if (connectionType == Network.none) {
        // Cancel all downloads if network is lost
        for (final type in ModelType.values) {
          if (isDownloading(type)) {
            cancelDownload(type);
            _downloadStatus[type]?.value =
                'Mất kết nối internet - Đã hủy tải xuống';
          }
        }
        showError('Mất kết nối internet');
      } else {
        // Clear network error messages when connection is restored
        for (final type in ModelType.values) {
          if (_downloadStatus[type]?.value ==
              'Mất kết nối internet - Đã hủy tải xuống') {
            _downloadStatus[type]?.value = '';
          }
        }
      }
    });

    await _initialize();
  }

  @override
  void onClose() {
    // Cancel all active downloads and clean up cache files
    cancelAllDownloads();
    _cleanupAllCacheFiles();
    super.onClose();
  }

  // Getters for reactive values
  bool isDownloading(ModelType type) => _isDownloading[type]?.value ?? false;

  bool isDownloaded(ModelType type) => _isDownloaded[type]?.value ?? false;

  double downloadProgress(ModelType type) =>
      _downloadProgress[type]?.value ?? 0.0;

  String downloadStatus(ModelType type) => _downloadStatus[type]?.value ?? '';

  // Reactive getters
  RxBool isDownloadingRx(ModelType type) => _isDownloading[type]!;

  RxBool isDownloadedRx(ModelType type) => _isDownloaded[type]!;

  RxDouble downloadProgressRx(ModelType type) => _downloadProgress[type]!;

  RxString downloadStatusRx(ModelType type) => _downloadStatus[type]!;

  // Model info getters
  String getModelTitle(ModelType type) => _modelInfo[type]!['title'];

  String getModelDescription(ModelType type) =>
      _modelInfo[type]!['description'];

  IconData getModelIcon(ModelType type) => _modelInfo[type]!['icon'];

  String getModelSize(ModelType type) => _modelInfo[type]!['size'];

  List<String> getModelFiles(ModelType type) =>
      List<String>.from(_modelInfo[type]!['files']);

  /// Check which models are already downloaded (iOS-safe with relative paths)
  Future<void> _checkExistingModels() async {
    try {
      debugPrint('=== Checking Existing Models (iOS-safe) ===');

      // Check suggestions model
      final suggestionsAbsolutePath =
          await _getStoredAbsolutePath('dataModelSuggestionsPath');
      debugPrint('Suggestions path: $suggestionsAbsolutePath');

      if (suggestionsAbsolutePath != null &&
          suggestionsAbsolutePath.isNotEmpty &&
          await File(suggestionsAbsolutePath).exists()) {
        _isDownloaded[ModelType.suggestions]?.value = true;
        _downloadProgress[ModelType.suggestions]?.value = 100.0;
        _downloadStatus[ModelType.suggestions]?.value = 'Đã tải xuống';
        debugPrint('✓ Suggestions model found');
      } else {
        debugPrint('✗ Suggestions model not found');
      }

      // Check STT models
      final encoderAbsolutePath =
          await _getStoredAbsolutePath('dataModelSTTEncoderPath');
      final decoderAbsolutePath =
          await _getStoredAbsolutePath('dataModelSTTDecoderPath');
      final joinerAbsolutePath =
          await _getStoredAbsolutePath('dataModelSTTJoinerPath');
      final tokensAbsolutePath =
          await _getStoredAbsolutePath('dataModelSTTTokensPath');

      debugPrint('STT paths:');
      debugPrint('  Encoder: $encoderAbsolutePath');
      debugPrint('  Decoder: $decoderAbsolutePath');
      debugPrint('  Joiner: $joinerAbsolutePath');
      debugPrint('  Tokens: $tokensAbsolutePath');

      bool allSttFilesExist = false;
      if (encoderAbsolutePath != null &&
          encoderAbsolutePath.isNotEmpty &&
          decoderAbsolutePath != null &&
          decoderAbsolutePath.isNotEmpty &&
          joinerAbsolutePath != null &&
          joinerAbsolutePath.isNotEmpty &&
          tokensAbsolutePath != null &&
          tokensAbsolutePath.isNotEmpty) {
        final encoderExists = await File(encoderAbsolutePath).exists();
        final decoderExists = await File(decoderAbsolutePath).exists();
        final joinerExists = await File(joinerAbsolutePath).exists();
        final tokensExists = await File(tokensAbsolutePath).exists();

        debugPrint('STT file existence:');
        debugPrint('  Encoder: $encoderExists');
        debugPrint('  Decoder: $decoderExists');
        debugPrint('  Joiner: $joinerExists');
        debugPrint('  Tokens: $tokensExists');

        allSttFilesExist =
            encoderExists && decoderExists && joinerExists && tokensExists;
      }

      if (allSttFilesExist) {
        _isDownloaded[ModelType.speechToText]?.value = true;
        _downloadProgress[ModelType.speechToText]?.value = 100.0;
        _downloadStatus[ModelType.speechToText]?.value = 'Đã tải xuống';
        debugPrint('✓ All STT models found');
      } else {
        debugPrint('✗ STT models incomplete or not found');
      }

      debugPrint('=== Model Check Complete ===');
    } catch (e) {
      debugPrint('Error checking existing models: $e');
    }
  }

  /// Download a specific model type with optional URL
  Future<void> downloadModel(ModelType type, {String? downloadUrl}) async {
    debugPrint('=== Download Model Debug Info ===');
    debugPrint('Model Type: $type');
    debugPrint('Provided URL: $downloadUrl');
    debugPrint('Stored URL: ${_modelDownloadUrls[type]}');
    debugPrint('Is Downloading: ${_isDownloading[type]?.value}');
    debugPrint('Network Status: ${NetworkService.connectionType}');

    if (_isDownloading[type]?.value == true) {
      debugPrint('Model $type is already downloading');
      showError('Mô hình đang được tải xuống. Vui lòng đợi.');
      return;
    }

    if (!networkServiceStatus.isConnected) {
      debugPrint('No internet connection');
      _downloadStatus[type]?.value = 'Không có kết nối internet';
      showError('no_connect_internet'.tr);
      return;
    }

    // Use provided URL or fall back to stored URL
    final finalDownloadUrl = downloadUrl ?? _modelDownloadUrls[type];
    debugPrint('Final URL to use: $finalDownloadUrl');

    if (finalDownloadUrl == null || finalDownloadUrl.isEmpty) {
      debugPrint('ERROR: Download URL is empty or null');
      _downloadStatus[type]?.value = 'Lỗi: URL tải xuống không hợp lệ';
      showError('Lỗi: URL tải xuống không hợp lệ');
      return;
    }

    try {
      _isDownloading[type]?.value = true;
      _downloadProgress[type]?.value = 0.0;
      _downloadStatus[type]?.value = 'Đang chuẩn bị tải xuống...';

      await _downloadModelFromUrl(type, finalDownloadUrl);

      // Mark as downloaded and set final status
      _isDownloaded[type]?.value = true;
      _downloadStatus[type]?.value = 'Tải xuống hoàn tất';

      // Refresh the existing models check to ensure UI is updated
      await Future.delayed(
          const Duration(milliseconds: 500)); // Small delay for UI processing
      await _checkExistingModels();
    } catch (e) {
      _downloadStatus[type]?.value = 'Lỗi: ${e.toString()}';
      debugPrint('Error downloading model $type: $e');
    } finally {
      _isDownloading[type]?.value = false;
      // Clear the active task reference in case of any remaining reference
      _activeDownloadTasks[type] = null;
    }
  }

  /// Re-download a specific model type
  Future<void> redownloadModel(ModelType type, {String? downloadUrl}) async {
    await downloadModel(type, downloadUrl: downloadUrl);
  }

  /// Cancel download for a specific model type
  Future<void> cancelDownload(ModelType type) async {
    final activeTask = _activeDownloadTasks[type];
    if (activeTask == null) {
      debugPrint('No active download task found for model type: $type');
      // Still clean up cache file if it exists
      await _cleanupCacheFile(type);
      return;
    }

    try {
      debugPrint('Cancelling download for model type: $type');
      await activeTask.cancel();

      // Update UI state
      _isDownloading[type]?.value = false;
      _downloadProgress[type]?.value = 0.0;
      _downloadStatus[type]?.value = 'Đã hủy tải xuống';

      // Clear the active task reference
      _activeDownloadTasks[type] = null;

      // Clean up cache file
      await _cleanupCacheFile(type);

      debugPrint('Download cancelled successfully for model type: $type');
    } catch (e) {
      debugPrint('Error cancelling download for model type $type: $e');
      _downloadStatus[type]?.value = 'Lỗi khi hủy tải xuống: ${e.toString()}';

      // Still try to clean up cache file
      await _cleanupCacheFile(type);
    }
  }

  /// Cancel all active downloads
  Future<void> cancelAllDownloads() async {
    final List<Future<void>> cancellationTasks = [];

    for (final type in ModelType.values) {
      if (_isDownloading[type]?.value == true) {
        cancellationTasks.add(cancelDownload(type));
      }
    }

    if (cancellationTasks.isNotEmpty) {
      await Future.wait(cancellationTasks);
      debugPrint('All active downloads cancelled');
    }
  }

  /// Download model from URL with cache-based strategy
  Future<void> _downloadModelFromUrl(ModelType type, String downloadUrl) async {
    try {
      // Use predefined filenames based on model type
      final fileName = _getPredefinedFileName(type);
      debugPrint('Downloading $fileName for model type: $type');

      // Detect file type and determine handling strategy
      final fileType = _detectFileType(fileName);
      debugPrint('Detected file type: $fileType for file: $fileName');

      // Create cache directory for temporary download
      final cacheDir = await _createCacheDirectory();

      // Download file to cache first
      final cacheFile =
          await _downloadFileToCache(downloadUrl, fileName, cacheDir, type);

      // Create final models directory
      final modelsDir = await _createModelsDirectory();

      // Move from cache to final destination and process
      await _processCachedFile(cacheFile, fileType, type, modelsDir);

      debugPrint('Model download and processing completed for type: $type');
    } catch (e) {
      debugPrint('Error in _downloadModelFromUrl: $e');
      // Clean up cache file on error
      await _cleanupCacheFile(type);
      rethrow;
    }
  }

  /// Get predefined filename based on model type
  String _getPredefinedFileName(ModelType type) {
    switch (type) {
      case ModelType.suggestions:
        return 'suggestions.onnx';
      case ModelType.speechToText:
        return 'stt_model.zip'; // STT models are typically ZIP files
    }
  }

  /// Download file to cache directory with progress tracking
  Future<File> _downloadFileToCache(
      String url, String fileName, String cacheDir, ModelType type) async {
    final cacheFilePath = '$cacheDir/$fileName';
    final cacheFile = File(cacheFilePath);

    // Store cache file path for cleanup
    _cacheFilePaths[type] = cacheFilePath;

    // Delete existing cache file if it exists
    if (await cacheFile.exists()) {
      await cacheFile.delete();
    }

    _downloadStatus[type]?.value = 'Đang tải xuống $fileName...';

    // Use DownloadTaskService for download with progress tracking
    final downloadTask = await DownloadTaskService.download(
      Uri.parse(url),
      file: cacheFile,
      deleteOnError: true,
    );

    // Store the active download task for potential cancellation
    _activeDownloadTasks[type] = downloadTask;

    // Listen to download progress
    await for (final event in downloadTask.events) {
      switch (event.state) {
        case TaskState.downloading:
          final bytesReceived = event.bytesReceived ?? 0;
          final totalBytes = event.totalBytes;

          if (totalBytes != null && totalBytes > 0) {
            final progress =
                (bytesReceived / totalBytes * 100).clamp(0.0, 100.0);
            _downloadProgress[type]?.value = progress;
            final bytesReceivedMb = bytesReceived ~/ 1024 ~/ 1024;
            final totalBytesMb = totalBytes ~/ 1024 ~/ 1024;
            _downloadStatus[type]?.value =
                "Đang tải xuống...\n${NumberFormat('###,###').format(bytesReceivedMb)}/${NumberFormat('###,###').format(totalBytesMb)} MB";
          } else {
            // Total bytes not known yet, show indeterminate progress
            _downloadStatus[type]?.value = 'Đang tải xuống...';
          }
          break;

        case TaskState.success:
          _downloadProgress[type]?.value = 100.0; // Ensure progress is 100%
          _downloadStatus[type]?.value = 'Tải xuống hoàn tất, đang xử lý...';
          _activeDownloadTasks[type] = null; // Clear the task reference
          return cacheFile;

        case TaskState.error:
          _activeDownloadTasks[type] = null; // Clear the task reference
          throw Exception('Download failed: ${event.error}');

        case TaskState.canceled:
          _activeDownloadTasks[type] = null; // Clear the task reference
          throw Exception('Download was canceled');

        case TaskState.paused:
          _downloadStatus[type]?.value = 'Tạm dừng tải xuống';
          break;
      }
    }

    return cacheFile;
  }

  /// Process cached file by moving to destination and handling based on type
  Future<void> _processCachedFile(File cacheFile, FileType fileType,
      ModelType modelType, String baseDir) async {
    _downloadStatus[modelType]?.value = 'Đang xử lý file...';

    try {
      switch (fileType) {
        case FileType.suggestionOnnx:
          await _processCachedSuggestionFile(cacheFile, baseDir, modelType);
          break;

        case FileType.sttZip:
          await _processCachedSttFile(cacheFile, baseDir, modelType);
          break;

        case FileType.genericOnnx:
          await _processCachedGenericOnnxFile(cacheFile, modelType, baseDir);
          break;

        case FileType.genericZip:
          await _processCachedGenericZipFile(cacheFile, modelType, baseDir);
          break;

        case FileType.unknown:
          throw Exception('Unknown file type, cannot process');
      }

      // Clean up cache file after successful processing
      await _cleanupCacheFile(modelType);
    } catch (e) {
      // Clean up cache file on error
      await _cleanupCacheFile(modelType);
      rethrow;
    }
  }

  /// Detect file type based on filename patterns
  FileType _detectFileType(String fileName) {
    final lowerFileName = fileName.toLowerCase();

    // Check for predefined suggestion models
    if (lowerFileName == 'suggestions.onnx') {
      return FileType.suggestionOnnx;
    }

    // Check for predefined STT models
    if (lowerFileName == 'stt_model.zip') {
      return FileType.sttZip;
    }

    // Legacy patterns for backward compatibility
    if (lowerFileName.contains('suggestion') &&
        lowerFileName.endsWith('.onnx')) {
      return FileType.suggestionOnnx;
    }

    if (lowerFileName.contains('stt') && lowerFileName.endsWith('.zip')) {
      return FileType.sttZip;
    }

    // Default to generic ONNX or ZIP based on extension
    if (lowerFileName.endsWith('.onnx')) {
      return FileType.genericOnnx;
    } else if (lowerFileName.endsWith('.zip')) {
      return FileType.genericZip;
    }

    return FileType.unknown;
  }

  /// Process cached suggestion ONNX file
  Future<void> _processCachedSuggestionFile(
      File cacheFile, String baseDir, ModelType type) async {
    final targetPath = '$baseDir/suggestions/model_v3.onnx';
    await _moveFromCacheToDestination(cacheFile, targetPath);

    // Store relative path for iOS compatibility
    _storeRelativePath('dataModelSuggestionsPath', targetPath);
    debugPrint('Suggestion model moved from cache to: $targetPath');
    debugPrint('Stored relative path: ${_getRelativePath(targetPath)}');
  }

  /// Process cached STT ZIP file
  Future<void> _processCachedSttFile(
      File cacheFile, String baseDir, ModelType type) async {
    final sttDir = '$baseDir/stt';

    // Extract ZIP to temporary location first
    final tempExtractDir = '${cacheFile.parent.path}/temp_stt_extract';
    await _extractZipToDirectory(cacheFile, tempExtractDir, {
      'encoder': 'vietnamese_encoder.onnx',
      'decoder': 'vietnamese_decoder.onnx',
      'joiner': 'vietnamese_joiner.onnx',
      'tokens': 'vietnamese_tokens.txt',
    });

    // Move extracted files to final destination
    final extractDir = Directory(tempExtractDir);
    if (await extractDir.exists()) {
      final files = await extractDir.list().toList();
      for (final file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          final targetPath = '$sttDir/$fileName';
          await _moveFromCacheToDestination(file, targetPath);
        }
      }

      // Clean up temporary extract directory
      await extractDir.delete(recursive: true);
    }

    // Store relative paths for iOS compatibility
    _storeRelativePath(
        'dataModelSTTEncoderPath', '$sttDir/vietnamese_encoder.onnx');
    _storeRelativePath(
        'dataModelSTTDecoderPath', '$sttDir/vietnamese_decoder.onnx');
    _storeRelativePath(
        'dataModelSTTJoinerPath', '$sttDir/vietnamese_joiner.onnx');
    _storeRelativePath(
        'dataModelSTTTokensPath', '$sttDir/vietnamese_tokens.txt');

    debugPrint('STT models moved from cache to: $sttDir');
    debugPrint('Stored relative paths:');
    debugPrint(
        '  Encoder: ${_getRelativePath('$sttDir/vietnamese_encoder.onnx')}');
    debugPrint(
        '  Decoder: ${_getRelativePath('$sttDir/vietnamese_decoder.onnx')}');
    debugPrint(
        '  Joiner: ${_getRelativePath('$sttDir/vietnamese_joiner.onnx')}');
    debugPrint(
        '  Tokens: ${_getRelativePath('$sttDir/vietnamese_tokens.txt')}');
  }

  /// Process cached generic ONNX file
  Future<void> _processCachedGenericOnnxFile(
      File cacheFile, ModelType modelType, String baseDir) async {
    String targetDir;
    String targetFileName;

    switch (modelType) {
      case ModelType.suggestions:
        targetDir = '$baseDir/suggestions';
        targetFileName = 'model_v3.onnx';
        break;
      default:
        throw Exception(
            'Generic ONNX file not supported for model type: $modelType');
    }

    final targetPath = '$targetDir/$targetFileName';
    await _moveFromCacheToDestination(cacheFile, targetPath);

    // Store relative path for iOS compatibility
    if (modelType == ModelType.suggestions) {
      _storeRelativePath('dataModelSuggestionsPath', targetPath);
    }

    debugPrint('Generic ONNX file moved from cache to: $targetPath');
    debugPrint('Stored relative path: ${_getRelativePath(targetPath)}');
  }

  /// Process cached generic ZIP file
  Future<void> _processCachedGenericZipFile(
      File cacheFile, ModelType modelType, String baseDir) async {
    switch (modelType) {
      case ModelType.speechToText:
        await _processCachedSttFile(cacheFile, baseDir, modelType);
        return;
      default:
        throw Exception(
            'Generic ZIP file not supported for model type: $modelType');
    }
  }

  /// Get the current Documents directory path (iOS-safe)
  Future<String> _getDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Convert absolute path to relative path from Documents directory
  String _getRelativePath(String absolutePath) {
    // Extract the relative part after /Documents/
    final documentsIndex = absolutePath.indexOf('/Documents/');
    if (documentsIndex != -1) {
      return absolutePath.substring(documentsIndex + '/Documents/'.length);
    }

    // If no /Documents/ found, check if it's already relative
    if (!absolutePath.startsWith('/')) {
      return absolutePath;
    }

    // Fallback: return the path as-is if we can't determine relative path
    debugPrint('Warning: Could not convert to relative path: $absolutePath');
    return absolutePath;
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

  /// Store relative path in preferences (iOS-safe)
  void _storeRelativePath(String prefKey, String absolutePath) {
    final relativePath = _getRelativePath(absolutePath);
    debugPrint(
        'Storing relative path - Key: $prefKey, Relative: $relativePath');

    // Store the relative path in preferences
    switch (prefKey) {
      case 'dataModelSuggestionsPath':
        AppPref.dataModelSuggestionsPath = relativePath;
        break;
      case 'dataModelSTTEncoderPath':
        AppPref.dataModelSTTEncoderPath = relativePath;
        break;
      case 'dataModelSTTDecoderPath':
        AppPref.dataModelSTTDecoderPath = relativePath;
        break;
      case 'dataModelSTTJoinerPath':
        AppPref.dataModelSTTJoinerPath = relativePath;
        break;
      case 'dataModelSTTTokensPath':
        AppPref.dataModelSTTTokensPath = relativePath;
        break;
    }
  }

  /// Get absolute path from stored relative path (iOS-safe)
  Future<String?> _getStoredAbsolutePath(String prefKey) async {
    String? relativePath;

    switch (prefKey) {
      case 'dataModelSuggestionsPath':
        relativePath = AppPref.dataModelSuggestionsPath;
        break;
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

  /// Check if a file should be ignored during ZIP extraction
  bool _shouldIgnoreFile(String fileName, String fullPath) {
    // macOS system files
    if (fullPath.contains('__macosx') ||
        fullPath.contains('__MACOSX') ||
        fileName == '.ds_store' ||
        fileName == '.DS_Store') {
      return true;
    }

    // Hidden files and directories (starting with dot)
    if (fileName.startsWith('.')) {
      return true;
    }

    // Empty directories or directory markers
    if (fileName.isEmpty || fullPath.endsWith('/')) {
      return true;
    }

    return false;
  }

  /// Extract ZIP file to directory with file mapping
  Future<void> _extractZipToDirectory(
      File zipFile, String targetDir, Map<String, String> fileMapping) async {
    try {
      // Read ZIP file
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Ensure target directory exists
      final dir = Directory(targetDir);
      await dir.create(recursive: true);

      // Extract files
      for (final file in archive) {
        if (file.isFile) {
          final fileName = file.name.split('/').last.toLowerCase();
          final fullPath = file.name.toLowerCase();
          debugPrint('Processing file: $fileName (full path: $fullPath)');

          // Skip unwanted files and directories
          if (_shouldIgnoreFile(fileName, fullPath)) {
            debugPrint('Skipping ignored file: $fileName');
            continue;
          }
          String? targetFileName;

          // Check if we have a specific mapping for this file
          for (final entry in fileMapping.entries) {
            if (fileName.contains(entry.key.toLowerCase())) {
              targetFileName = entry.value;
              break;
            }
          }

          // If no mapping found, use original filename
          targetFileName ??= fileName;

          final targetPath = '$targetDir/$targetFileName';
          final targetFile = File(targetPath);

          // Write file content
          await targetFile.writeAsBytes(file.content as List<int>);
          debugPrint('Extracted: $fileName -> $targetFileName -> $targetPath');
        }
      }

      debugPrint('ZIP extraction completed to: $targetDir');
    } catch (e) {
      debugPrint('Error extracting ZIP file: $e');
      rethrow;
    }
  }

  /// Create cache directory for temporary downloads
  Future<String> _createCacheDirectory() async {
    // Get platform-appropriate cache directory
    Directory cacheDir;
    if (Platform.isAndroid) {
      // Use external cache directory for Android
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        cacheDir = Directory('${externalDir.path}/cache/ai_downloads');
      } else {
        // Fallback to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        cacheDir = Directory('${appDir.path}/cache/ai_downloads');
      }
    } else {
      // Use documents cache for iOS
      final appDir = await getApplicationDocumentsDirectory();
      cacheDir = Directory('${appDir.path}/cache/ai_downloads');
    }

    // Create cache directory if it doesn't exist
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
      debugPrint('Created cache directory: ${cacheDir.path}');
    }

    return cacheDir.path;
  }

  /// Clean up cache file for a specific model type
  Future<void> _cleanupCacheFile(ModelType type) async {
    final cacheFilePath = _cacheFilePaths[type];
    if (cacheFilePath != null) {
      try {
        final cacheFile = File(cacheFilePath);
        if (await cacheFile.exists()) {
          await cacheFile.delete();
          debugPrint('Cleaned up cache file: $cacheFilePath');
        }
      } catch (e) {
        debugPrint('Warning: Could not clean up cache file $cacheFilePath: $e');
      } finally {
        _cacheFilePaths[type] = null;
      }
    }
  }

  /// Clean up all cache files
  Future<void> _cleanupAllCacheFiles() async {
    for (final type in ModelType.values) {
      await _cleanupCacheFile(type);
    }
  }

  /// Move file from cache to final destination with atomic operation
  Future<void> _moveFromCacheToDestination(
      File cacheFile, String destinationPath) async {
    try {
      // Ensure destination directory exists
      final destinationDir = Directory(destinationPath).parent;
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      // Perform atomic move operation
      final destinationFile = File(destinationPath);

      // If destination exists, delete it first
      if (await destinationFile.exists()) {
        await destinationFile.delete();
      }

      // Copy file to destination
      await cacheFile.copy(destinationPath);

      // Verify the copy was successful
      if (await destinationFile.exists()) {
        // Delete the cache file after successful copy
        await cacheFile.delete();
        debugPrint('Successfully moved file from cache to: $destinationPath');
      } else {
        throw Exception('Failed to verify file copy to destination');
      }
    } catch (e) {
      debugPrint('Error moving file from cache to destination: $e');
      rethrow;
    }
  }

  /// Create models directory structure
  Future<String> _createModelsDirectory() async {
    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // Get base directory
    final baseDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (baseDir == null) {
      throw Exception('Unable to access storage directory');
    }

    // Create models directory
    final modelsDir = Directory('${baseDir.path}/models');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }

    // Create subdirectories for each model type
    final suggestionsDir = Directory('${modelsDir.path}/suggestions');
    final sttDir = Directory('${modelsDir.path}/stt');

    await suggestionsDir.create(recursive: true);
    await sttDir.create(recursive: true);

    return modelsDir.path;
  }

  /// Set download URL for a specific model type
  void setModelDownloadUrl(ModelType type, String url) {
    _modelDownloadUrls[type] = url;
    debugPrint('Set download URL for $type: $url');
  }

  /// Get download URL for a specific model type
  String? getModelDownloadUrl(ModelType type) {
    return _modelDownloadUrls[type];
  }

  /// Get all model types
  List<ModelType> getAllModelTypes() {
    return ModelType.values;
  }

  /// Check if a specific model can be cancelled (has active download)
  bool canCancelDownload(ModelType type) {
    return _isDownloading[type]?.value == true &&
        _activeDownloadTasks[type] != null;
  }

  /// Check if any model can be cancelled
  bool get canCancelAnyDownload {
    return ModelType.values.any((type) => canCancelDownload(type));
  }

  /// Get reactive boolean for cancel button state for specific model
  RxBool canCancelDownloadRx(ModelType type) {
    // Create a computed reactive boolean based on download state
    return _isDownloading[type]!;
  }

  /// Cancel download with UI feedback (for button integration)
  Future<void> cancelDownloadWithFeedback(ModelType type) async {
    if (!canCancelDownload(type)) {
      debugPrint('Cannot cancel download for $type - no active download');
      return;
    }

    try {
      _downloadStatus[type]?.value = 'Đang hủy tải xuống...';
      await cancelDownload(type);
    } catch (e) {
      _downloadStatus[type]?.value = 'Lỗi khi hủy: ${e.toString()}';
      debugPrint('Error in cancelDownloadWithFeedback: $e');
    }
  }

  /// Cancel all downloads with UI feedback
  Future<void> cancelAllDownloadsWithFeedback() async {
    if (!canCancelAnyDownload) {
      debugPrint('No active downloads to cancel');
      return;
    }

    try {
      // Update status for all downloading models
      for (final type in ModelType.values) {
        if (canCancelDownload(type)) {
          _downloadStatus[type]?.value = 'Đang hủy tải xuống...';
        }
      }

      await cancelAllDownloads();
    } catch (e) {
      debugPrint('Error in cancelAllDownloadsWithFeedback: $e');
    }
  }

  /// Check if any model is currently downloading (reactive)
  bool get isAnyModelDownloading {
    return _isDownloading[ModelType.suggestions]!.value ||
        _isDownloading[ModelType.speechToText]!.value;
  }

  /// Get overall download progress (average of all models) (reactive)
  double get overallProgress {
    final progress1 = _downloadProgress[ModelType.suggestions]!.value;
    final progress2 = _downloadProgress[ModelType.speechToText]!.value;
    return (progress1 + progress2) / 2;
  }

  /// Navigate back with download warning dialog if needed
  Future<void> backHome() async {
    // Check if any model is currently downloading
    if (isAnyModelDownloading) {
      // Show confirmation dialog
      final shouldGoBack = await _showDownloadWarningDialog();
      if (shouldGoBack == true) {
        // User confirmed to cancel downloads and go back
        await cancelAllDownloads();
        Get.back();
      }
      // If shouldGoBack is false or null, stay on current screen
    } else {
      // No downloads in progress, safe to go back
      Get.back();
    }
  }

  /// Show warning dialog when user tries to navigate back during downloads
  Future<bool?> _showDownloadWarningDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Đang tải xuống'),
        content: const Text(
            'Hiện tại có mô hình đang được tải xuống. Bạn có muốn hủy tải xuống và quay lại không?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Tiếp tục tải xuống'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hủy và quay lại'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _getModelDownloadConfig() async {
    debugPrint('=== Getting Model Download Config ===');
    try {
      final suggestionsResponse = await dataRepository.getModelVersion();
      // final speechToTextResponse = await dataRepository.getModelSpeech();
      final suggestions = suggestionsResponse.objectData;
      // final speechToText = speechToTextResponse.body;
      debugPrint('modelVersion: $suggestions');
      // debugPrint('speechToText: $speechToText');
      final suggestionsUrl = suggestions?.modelFileUrl;
      // final speechToTextUrl = speechToText?.modelFileUrl;

      // if (suggestionsUrl == null || speechToTextUrl == null) {
      //   debugPrint(
      //       'ERROR: Suggestions or STT URL is null in _getModelDownloadConfig');
      //   debugPrint('Suggestions URL: $suggestionsUrl');
      //   debugPrint('STT URL: $speechToTextUrl');
      //   return;
      // }
      if (suggestionsUrl == null) {
        debugPrint(
            'ERROR: Suggestions or STT URL is null in _getModelDownloadConfig');
        debugPrint('Suggestions URL: $suggestionsUrl');
        //  debugPrint('STT URL: $speechToTextUrl');
        return;
      }
      _modelDownloadUrls[ModelType.suggestions] = suggestionsUrl;
      //  _modelDownloadUrls[ModelType.speechToText] = speechToTextUrl;

      debugPrint('SUCCESS: URLs set successfully');
      debugPrint(
          'Suggestions URL: ${_modelDownloadUrls[ModelType.suggestions]}');
      debugPrint('STT URL: ${_modelDownloadUrls[ModelType.speechToText]}');
    } catch (e) {
      debugPrint('ERROR in _getModelDownloadConfig: $e');
    }
  }

  /// Migrate existing absolute paths to relative paths (iOS compatibility)
  Future<void> _migrateToRelativePaths() async {
    debugPrint('=== Migrating to Relative Paths ===');

    try {
      // Migrate suggestions path
      final suggestionsPath = AppPref.dataModelSuggestionsPath;
      if (suggestionsPath.isNotEmpty && suggestionsPath.startsWith('/')) {
        final relativePath = _getRelativePath(suggestionsPath);
        AppPref.dataModelSuggestionsPath = relativePath;
        debugPrint(
            'Migrated suggestions path: $suggestionsPath -> $relativePath');
      }

      // Migrate STT paths
      // final encoderPath = AppPref.dataModelSTTEncoderPath;
      // if (encoderPath.isNotEmpty && encoderPath.startsWith('/')) {
      //   final relativePath = _getRelativePath(encoderPath);
      //   AppPref.dataModelSTTEncoderPath = relativePath;
      //   debugPrint('Migrated encoder path: $encoderPath -> $relativePath');
      // }

      // final decoderPath = AppPref.dataModelSTTDecoderPath;
      // if (decoderPath.isNotEmpty && decoderPath.startsWith('/')) {
      //   final relativePath = _getRelativePath(decoderPath);
      //   AppPref.dataModelSTTDecoderPath = relativePath;
      //   debugPrint('Migrated decoder path: $decoderPath -> $relativePath');
      // }

      // final joinerPath = AppPref.dataModelSTTJoinerPath;
      // if (joinerPath.isNotEmpty && joinerPath.startsWith('/')) {
      //   final relativePath = _getRelativePath(joinerPath);
      //   AppPref.dataModelSTTJoinerPath = relativePath;
      //   debugPrint('Migrated joiner path: $joinerPath -> $relativePath');
      // }

      // final tokensPath = AppPref.dataModelSTTTokensPath;
      // if (tokensPath.isNotEmpty && tokensPath.startsWith('/')) {
      //   final relativePath = _getRelativePath(tokensPath);
      //   AppPref.dataModelSTTTokensPath = relativePath;
      //   debugPrint('Migrated tokens path: $tokensPath -> $relativePath');
      // }

      debugPrint('=== Migration Complete ===');
    } catch (e) {
      debugPrint('Error during path migration: $e');
    }
  }

  _initialize() async {
    debugPrint('Initializing Enhanced AI Download Controller');
    loadingSubject.add(true);
    await _migrateToRelativePaths(); // Migrate existing paths first
    await _getModelDownloadConfig();
    await _checkExistingModels();
    loadingSubject.add(false);
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
