import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math'; 

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:onnxruntime/onnxruntime.dart'; 

import '../models/predict_model.dart';
import '../models/tuple_2_model.dart';
import '../utils/asset_utils_v2.dart';
import './text_tokenizer_service.dart';

/// Evaluator for Industry Code classification using PhoBERT and ONNX Runtime
/// Singleton service accessible via Get.find IndustryCodeEvaluator
class IndustryCodeEvaluatorV2 extends GetxService {
  static final Logger _logger = Logger('IndustryCodeEvaluatorV2');

  final int maxLength;
  final int batchSize;

  OrtSession? _session;
  late PhoBERTTokenizer tokenizer;
  late Map<int, String> _labelEncoder; // Maps index to code
  late Map<String, int> _labelDecoder; // Maps code to index
  late Map<String, double> _codeFrequencies;
  late Map<String, String> _codeDescriptions; // Maps MaNganh to MotaNganh

  bool _isInitialized = false;
  bool _isInitializing = false;

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if the service is currently initializing
  bool get isInitializing => _isInitializing;

  /// Constructor with optional parameters
  IndustryCodeEvaluatorV2({
    this.maxLength = 96,
    this.batchSize = 16,
    this.isDebug = false,
  });

  /// Debug flag
  bool isDebug;

  /// Initialize the evaluator by loading the model and tokenizer
  /// This method is safe to call multiple times - it will only initialize once
  Future<void> initialize() async {
    // If already initialized, return immediately
    if (_isInitialized) {
      _logger.info("IndustryCodeEvaluator already initialized");
      return;
    }

    // If currently initializing, wait for it to complete
    if (_isInitializing) {
      _logger.info("IndustryCodeEvaluator is already initializing, waiting...");
      // Wait until initialization is complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _isInitializing = true;

    try {
      _logger.info("Starting IndustryCodeEvaluator initialization...");

      // Initialize tokenizer
      tokenizer = PhoBERTTokenizer();
      await tokenizer.initialize();

      // Load resources
      await _loadLabelEncodings();
      await _loadCodeFrequencies();
      await _loadIndustryCodeDescriptions();
      await _initializeOnnxSession();

      _isInitialized = true;
      _logger.info("IndustryCodeEvaluator initialized successfully");
    } catch (e) {
      _logger.severe("Initialization failed: ${e.toString()}");
      _isInitialized = false;
      throw Exception(
          "Failed to initialize IndustryCodeEvaluator: ${e.toString()}");
    } finally {
      _isInitializing = false;
    }
  }

  /// Get the model file from storage
  Future<File?> _getModelFile() async {
    try {
      // Try to get from stored path first (iOS-safe)
      final suggestionsPath =
          await AssetUtils.getStoredModelPath('dataModelSuggestionsPath');

      if (suggestionsPath != null && suggestionsPath.isNotEmpty) {
        final file = File(suggestionsPath);
        if (await file.exists()) {
          return file;
        }
      }

      // Fallback to legacy path
      final file = await AssetUtils.localFile;
      if (file.existsSync()) {
        return file;
      }

      return null;
    } catch (e) {
      _logger.warning("Error getting model file: ${e.toString()}");
      return null;
    }
  }

  /// Initialize ONNX Runtime session using background isolate
  Future<void> _initializeOnnxSession() async {
    try {
      final modelFile = await _getModelFile();

      if (modelFile == null || !await modelFile.exists()) {
        throw Exception(
            "Model file not found. Please download the AI models first.");
      }

      _logger.info("Loading model from: ${modelFile.path}");

      // Load model in background using compute to avoid blocking UI
      _session = await compute(_loadModelInBackground, modelFile.path);

      // Inspect model in debug builds
      if (isDebug) {
        _inspectOnnxModel(_session!);
      }

      _logger.info("ONNX session initialized successfully");
    } catch (e) {
      _logger.severe("Error initializing ONNX session: ${e.toString()}");
      throw Exception("Failed to initialize ONNX session: ${e.toString()}");
    }
  }

  /// Background function to load ONNX model (runs in isolate)
  static OrtSession _loadModelInBackground(String modelPath) {
    final file = File(modelPath);

    // Create session options
    final sessionOptions = OrtSessionOptions()
      ..setIntraOpNumThreads(min(Platform.numberOfProcessors, 4))
      ..setInterOpNumThreads(min(Platform.numberOfProcessors, 4))
      ..setSessionGraphOptimizationLevel(GraphOptimizationLevel.ortDisableAll);

    // Create the session from file (more efficient for large models)
    return OrtSession.fromFile(file, sessionOptions);
  }

  /// Inspect and log details about the ONNX model
  void _inspectOnnxModel(OrtSession session) {
    try {
      // Get input information
      final inputInfos = session.inputNames;
      _logger.info("Model has ${inputInfos.length} inputs:");

      for (final name in inputInfos) {
        // final info = session.getInputTypeInfo(name);
        // final shape = info.shape;
        _logger.info("- Input: '$name' with shape: $name");
      }

      // Get output information
      final outputInfos = session.outputNames;
      _logger.info("Model has ${outputInfos.length} outputs:");

      for (final name in outputInfos) {
        // final info = session.getOutputTypeInfo(name);
        // final shape = info.shape;
        _logger.info("- Output: '$name' with shape: $name");
      }
    } catch (e) {
      _logger.severe("Error inspecting model: ${e.toString()}");
    }
  }

  /// Load industry code descriptions from JSON or CSV
  Future<void> _loadIndustryCodeDescriptions() async {
    try {
      _codeDescriptions = await AssetUtils.loadIndustryCodeDataset();

      _logger.info(
          "Loaded ${_codeDescriptions.length} industry code descriptions from CSV");
    } catch (e) {
      _logger
          .severe("Error loading industry code descriptions: ${e.toString()}");
      _codeDescriptions = {};
    }
  }

  // /// Get model file from assets
  // Future<File> _ensureModelFile(String assetName) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final modelFile = File('${directory.path}/$assetName');
  //
  //   // Check if file already exists
  //   if (!await modelFile.exists()) {
  //     // Copy from assets
  //     final byteData = await rootBundle.load('assets/models/$assetName');
  //     final buffer = byteData.buffer.asUint8List();
  //     await modelFile.writeAsBytes(buffer);
  //     _logger.info("Model file copied from assets to ${modelFile.path}");
  //   } else {
  //     _logger.info("Model file already exists at ${modelFile.path}");
  //   }
  //
  //   return modelFile;
  // }

  /// Normalize text similar to the Python implementation
  String _normalizeText(String text) {
    // Simple normalization - adapt based on your Python implementation
    return text.trim().toLowerCase();
  }

  /// Load label encodings from JSON file
  /// Selects appropriate label encoder based on which model file exists:
  /// - If model_v4.onnx exists: use label_encoder_v4.json
  /// - Else if model_v3.onnx exists: use label_encoder.json
  /// - Otherwise: throw error
  Future<void> _loadLabelEncodings() async {
    try {
      final modelFile = await _getModelFile();

      if (modelFile == null || !await modelFile.exists()) {
        throw Exception(
            "No model file found. Please download the AI models first.");
      }

      // Get the filename from the model file path
      final fileName = modelFile.path.split('/').last;
      _logger.info("Detected model file: $fileName");

      // Select label encoder based on model filename
      if (fileName == 'model_v4.onnx') {
        // Use v4 label encoder for v4 model
        final labels = await AssetUtils.loadLabelEncoderAndDecoderV4();
        _labelEncoder = labels.item1;
        _labelDecoder = labels.item2;
        _logger
            .info("Loaded ${_labelEncoder.length} label encodings (v4 model)");
      } else if (fileName == 'model_v3.onnx') {
        // Use v3 label encoder for v3 model
        final labels = await AssetUtils.loadLabelEncoderAndDecoder();
        _labelEncoder = labels.item1;
        _labelDecoder = labels.item2;
        _logger
            .info("Loaded ${_labelEncoder.length} label encodings (v3 model)");
      } else {
        // Unknown model file, try v4 first as default
        _logger.warning(
            "Unknown model filename: $fileName, attempting to use v4 label encoder");
        final labels = await AssetUtils.loadLabelEncoderAndDecoderV4();
        _labelEncoder = labels.item1;
        _labelDecoder = labels.item2;
        _logger.info(
            "Loaded ${_labelEncoder.length} label encodings (default v4)");
      }

      _logger.info("Loaded ${_labelDecoder.length} label decodings");
    } catch (e) {
      _logger.severe("Failed to load label encodings: ${e.toString()}");
      // If file doesn't exist, create empty maps
      _labelEncoder = {};
      _labelDecoder = {};
    }
  }

  /// Load code frequencies from JSON file
  Future<void> _loadCodeFrequencies() async {
    try {
      _codeFrequencies = await AssetUtils.loadCodeFrequencies();
      _logger.info("Loaded ${_codeFrequencies.length} code frequencies");
    } catch (e) {
      _logger.severe("Failed to load code frequencies: ${e.toString()}");
      _codeFrequencies = {};
    }
  }

  /// Predict industry codes for given texts
  Future<List<List<PredictionResult>>> predict(
    List<String> texts, {
    int topK = 100,
    bool useExactExpectedFormat = false,
  }) async {
    if (_session == null) {
      throw Exception("Model not initialized. Please initialize first.");
    }

    // Handle empty input gracefully
    if (texts.isEmpty) {
      _logger.warning(
          "Empty texts list provided to predict, returning empty result");
      return [[]];
    }

    final results = <List<PredictionResult>>[];
    final processedTexts = texts.map((text) => _normalizeText(text)).toList();

    // Process in batches
    for (int i = 0; i < processedTexts.length; i += batchSize) {
      final batchEnd = min(i + batchSize, processedTexts.length);
      final batchTexts = processedTexts.sublist(i, batchEnd);

      try {
        final batchResult = await _processBatch(batchTexts, topK);
        results.addAll(batchResult);
      } catch (e) {
        _logger.severe("Error during batch processing: ${e.toString()}");
        // Add empty results for this batch instead of throwing
        for (int j = 0; j < batchTexts.length; j++) {
          results.add([]);
        }
      }
    }

    // Final safety check - ensure we return at least one list (even if empty)
    if (results.isEmpty) {
      _logger.warning("No results generated, returning empty placeholder");
      return [[]];
    }

    return results;
  }

  /// Process a batch of texts for prediction
  Future<List<List<PredictionResult>>> _processBatch(
    List<String> batchTexts,
    int topK,
  ) async {
    // Prepare batch input
    final batchInput = _prepareBatchInput(batchTexts);
    final batchInputIds = batchInput.item1;
    final batchAttentionMasks = batchInput.item2;

    // Create inputs for model
    final inputs = <String, OrtValue>{};

    // Create input tensors
    final inputIdsTensor = OrtValueTensor.createTensorWithDataList(
      batchInputIds,
      [batchTexts.length, maxLength],
    );

    final attentionMaskTensor = OrtValueTensor.createTensorWithDataList(
      batchAttentionMasks,
      [batchTexts.length, maxLength],
    );

    // Use model's input names
    final session = _session!;
    final inputNames = session.inputNames;

    if (inputNames.contains('input_ids') &&
        inputNames.contains('attention_mask')) {
      inputs['input_ids'] = inputIdsTensor;
      inputs['attention_mask'] = attentionMaskTensor;
    } else if (inputNames.length >= 2) {
      inputs[inputNames[0]] = inputIdsTensor;
      inputs[inputNames[1]] = attentionMaskTensor;
    } else if (inputNames.length == 1) {
      inputs[inputNames[0]] = inputIdsTensor;
    } else {
      // Fallback
      inputs['input_ids'] = inputIdsTensor;
      inputs['attention_mask'] = attentionMaskTensor;
    }

    if (isDebug) {
      _logger.info(
          "Model inputs prepared with shapes: [${batchTexts.length}, $maxLength]");
    }

    // Run inference
    final List<OrtValue?> outputs = session.run(OrtRunOptions(), inputs);
    // Process output
    final batchResults = _processModelOutput(outputs, batchTexts.length, topK);
    // Clean up tensors
    inputIdsTensor.release();
    attentionMaskTensor.release();

    return batchResults;
  }

  /// Prepare batch input by tokenizing texts
  Tuple2<Int64List, Int64List> _prepareBatchInput(List<String> batchTexts) {
    final batchInputIds = Int64List(batchTexts.length * maxLength);
    final batchAttentionMasks = Int64List(batchTexts.length * maxLength);

    for (int i = 0; i < batchTexts.length; i++) {
      final text = batchTexts[i];
      final tokenizationOutput = tokenizer.createPythonStyleModelInput(text);
      final inputIds = tokenizationOutput.first;
      final attentionMask = tokenizationOutput.second;

      // Fill arrays with data
      for (int j = 0; j < maxLength; j++) {
        final flatIndex = i * maxLength + j;

        if (j < inputIds.length) {
          batchInputIds[flatIndex] = inputIds[j];
          batchAttentionMasks[flatIndex] = attentionMask[j];
        } else {
          // Padding
          batchInputIds[flatIndex] = 0;
          batchAttentionMasks[flatIndex] = 0;
        }
      }

      // Debug log only for the first example
      if (i == 0 && isDebug) {
        _logger.info("Sample tokenization - Input: $text");
        _logger.info("First 10 input_ids: ${inputIds.take(10).toList()}");
        _logger.info(
            "First 10 attention_mask: ${attentionMask.take(10).toList()}");
      }
    }

    return Tuple2(batchInputIds, batchAttentionMasks);
  }

  /// Process the model output to create prediction results

  List<List<PredictionResult>> _processModelOutput(
    List<OrtValue?> outputs,
    int batchSize,
    int topK,
  ) {
    final batchResults = <List<PredictionResult>>[];

    try {
      // Find output tensor - get the first value
      OrtValue? outputTensor = outputs.isNotEmpty ? outputs[0] : null;

      if (outputTensor == null) {
        _logger.severe("Could not find valid output tensor in model results");
        // Add empty results for this batch
        for (int i = 0; i < batchSize; i++) {
          batchResults.add([]);
        }
        return batchResults;
      }

      // The OrtValueTensor has a 'value' property that returns the tensor data
      final dynamic tensorValue = outputTensor.value;

      if (tensorValue is List) {
        if (tensorValue.isEmpty) {
          _logger.severe("Output tensor has no data");
          for (int i = 0; i < batchSize; i++) {
            batchResults.add([]);
          }
          return batchResults;
        }

        // Extract shape information from the first element if possible
        if (tensorValue[0] is List) {
          // It's a batch of predictions (2D data)
          for (int i = 0; i < tensorValue.length; i++) {
            final logits = (tensorValue[i] as List).cast<double>();
            final probabilities = _softmax(Float32List.fromList(logits));
            final topIndices = _getTopKIndices(probabilities, topK);
            final predictions = _createPredictions(topIndices, probabilities);
            batchResults.add(predictions);
          }
        } else {
          // It's a single prediction (1D data)
          final logits = tensorValue.cast<double>();
          final probabilities = _softmax(Float32List.fromList(logits));
          final topIndices = _getTopKIndices(probabilities, topK);
          final predictions = _createPredictions(topIndices, probabilities);
          batchResults.add(predictions);

          // If we were expecting more results but only got one, duplicate it to match batchSize
          for (int i = 1; i < batchSize; i++) {
            batchResults.add([]);
          }
        }
      } else {
        _logger.severe(
            "Unexpected output tensor type: ${tensorValue.runtimeType}");
        for (int i = 0; i < batchSize; i++) {
          batchResults.add([]);
        }
      }
    } catch (e) {
      _logger.severe("Error processing model output: ${e.toString()}");
      // Add empty results for this batch
      for (int i = 0; i < batchSize; i++) {
        batchResults.add([]);
      }
    } finally {
      // Release all output tensors
      for (var output in outputs) {
        try {
          output?.release();
        } catch (e) {
          _logger.warning("Error releasing tensor: $e");
        }
      }
    }

    return batchResults;
  }

  /// Create prediction results from indices and probabilities
  List<PredictionResult> _createPredictions(
    List<int> indices,
    Float32List probabilities,
  ) {
    return indices.map((idx) {
      final code = _labelEncoder[idx]?.padLeft(5, '0') ?? "UNKNOWN";
      final score = probabilities[idx];
      final frequency = _codeFrequencies[code] ?? 0.0;
      final description = _codeDescriptions[code] ?? "No description available";

      return PredictionResult(
        code: code,
        description: description,
        score: score,
        frequency: frequency,
      );
    }).toList();
  }

  /// Apply softmax to convert logits to probabilities
  Float32List _softmax(Float32List logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final expLogits = Float32List(logits.length);
    double sumExpLogits = 0;

    // Calculate exp(logit - maxLogit) for each logit and sum
    for (int i = 0; i < logits.length; i++) {
      expLogits[i] = exp(logits[i] - maxLogit).toDouble();
      sumExpLogits += expLogits[i];
    }

    // Normalize by sum
    for (int i = 0; i < expLogits.length; i++) {
      expLogits[i] = expLogits[i] / sumExpLogits;
    }

    return expLogits;
  }

  /// Get indices of top K values
  List<int> _getTopKIndices(Float32List values, int k) {
    // Create pairs of (index, value)
    final indexedValues = List<Tuple2<int, double>>.generate(
      values.length,
      (i) => Tuple2(i, values[i]),
    );

    // Sort by value in descending order
    indexedValues.sort((a, b) => b.item2.compareTo(a.item2));

    // Take top k indices
    return indexedValues.take(k).map((pair) => pair.item1).toList();
  }

  /// Close the session when finished
  /// Note: Since this is a singleton service, you typically don't need to call this
  /// The service will be kept alive for the lifetime of the app
  void close() {
    if (_session != null) {
      _logger.info("Closing ONNX session");
      _session?.release();
      _session = null;
    }
    _isInitialized = false;
  }

  /// Reset the service to uninitialized state
  /// This allows re-initialization if needed (e.g., after model update)
  void reset() {
    _logger.info("Resetting IndustryCodeEvaluator");
    close();
    _isInitializing = false;
  }

  /// GetX lifecycle method - called when service is removed from memory
  @override
  void onClose() {
    _logger.info("IndustryCodeEvaluator service is being disposed");
    close();
    super.onClose();
  }

  /// Test method for debugging tokenization using example text
  Future<List<List<PredictionResult>>> testPredictWithExactFormat() async {
    _logger.info("TESTING: Using tokenizer with sample text");
    final testTexts = ["test example", "another test sample"];
    return await predict(testTexts, topK: 100, useExactExpectedFormat: true);
  }
}
