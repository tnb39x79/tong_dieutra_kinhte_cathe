import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/tuple_2_model.dart';
import "package:logging/logging.dart";
import 'package:onnxruntime/onnxruntime.dart';

import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/predict_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/services/text_tokenizer_service.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/utils/asset_utils.dart';

/// Evaluator for Industry Code classification using PhoBERT and ONNX Runtime
class IndustryCodeEvaluator {
  static final Logger _logger = Logger('IndustryCodeEvaluator');

  final int maxLength;
  final int batchSize;

  OrtSession? _session;
  late PhoBERTTokenizer tokenizer;
  late Map<int, String> _labelEncoder; // Maps index to code
  late Map<String, int> _labelDecoder; // Maps code to index
  late Map<String, double> _codeFrequencies;
  late Map<String, String> _codeDescriptions; // Maps MaNganh to MotaNganh

  /// Constructor with optional parameters
  IndustryCodeEvaluator({
    this.maxLength = 96,
    this.batchSize = 16,
    this.isDebug = false,
  });

  /// Debug flag
  bool isDebug;

  /// Initialize the evaluator by loading the model and tokenizer
  Future<void> initialize() async {
    try {
      // Initialize tokenizer
      tokenizer = PhoBERTTokenizer();
      await tokenizer.initialize();

      // Load resources
      await _loadLabelEncodings();
      await _loadCodeFrequencies();
      await _loadIndustryCodeDescriptions();
      await _initializeOnnxSession();
    } catch (e) {
      _logger.severe("Initialization failed: ${e.toString()}");
      throw Exception("Failed to initialize IndustryCodeEvaluator: ${e.toString()}");
    }
  }

  /// Initialize ONNX Runtime session
  Future<void> _initializeOnnxSession() async {
    try {
      final bytes = await AssetUtils.loadIndustryOnnxModel();

      // Create session options
      final sessionOptions = OrtSessionOptions()
        ..setIntraOpNumThreads(min(Platform.numberOfProcessors, 4))
        ..setInterOpNumThreads(min(Platform.numberOfProcessors, 4))
        ..setSessionGraphOptimizationLevel(GraphOptimizationLevel.ortDisableAll);

      // Create the session
      _session =  OrtSession.fromBuffer(bytes, sessionOptions);

      // Inspect model in debug builds
      if (isDebug) {
        _inspectOnnxModel(_session!);
      }
    } catch (e) {
      _logger.severe("Error initializing ONNX session: ${e.toString()}");
      throw Exception("Failed to initialize ONNX session: ${e.toString()}");
    }
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

      _logger.info("Loaded ${_codeDescriptions.length} industry code descriptions from CSV");
    } catch (e) {
      _logger.severe("Error loading industry code descriptions: ${e.toString()}");
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
  Future<void> _loadLabelEncodings() async {
    try {
      final labels = await AssetUtils.loadLabelEncoderAndDecoder();
      _labelEncoder = labels.item1;
      _labelDecoder = labels.item2;

      _logger.info("Loaded ${_labelEncoder.length} label encodings");
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
      _logger.warning("Empty texts list provided to predict, returning empty result");
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

    if (inputNames.contains('input_ids') && inputNames.contains('attention_mask')) {
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
      _logger.info("Model inputs prepared with shapes: [${batchTexts.length}, $maxLength]");
    }

    // Run inference
    final List<OrtValue?> outputs =  session.run(OrtRunOptions(),inputs);
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
        _logger.info("First 10 attention_mask: ${attentionMask.take(10).toList()}");
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
        _logger.severe("Unexpected output tensor type: ${tensorValue.runtimeType}");
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
    return indexedValues
        .take(k)
        .map((pair) => pair.item1)
        .toList();
  }

  /// Close the session when finished
  void close() {
    _session = null;
  }

  /// Test method for debugging tokenization using example text
  Future<List<List<PredictionResult>>> testPredictWithExactFormat() async {
    _logger.info("TESTING: Using tokenizer with sample text");
    final testTexts = ["test example", "another test sample"];
    return await predict(testTexts, topK: 100, useExactExpectedFormat: true);
  }
}
