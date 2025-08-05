import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/model/vcpa_offline_ai/models/tuple_2_model.dart';

import 'package:logging/logging.dart';

abstract class AssetPaths {
  static const codeFrequencies = 'assets/data/code_frequencies.json';
  static const modelConfig = 'assets/data/config.json';
  static const industryCodesDataset = 'assets/data/industry_codes.csv';
  static const labelEncoder = 'assets/data/label_encoder.json';
  static const labelDecoder = 'assets/data/label_decoder.json';
  static const bpe = 'assets/data/bpe.codes';
  static const industryOnnxModel = 'assets/models/model_v3.onnx';
  static const industryOnnxModelStorage =
      '/storage/emulated/0/Android/data/gov.statistics.investigation.economic.testoffline/files/models/model_v3.onnx'; //
  static const vocabulary = 'assets/data/vocab.txt';
}

abstract class AssetUtils {
  static final Logger _logger = Logger('AssetUtils');

  static Future<String> _readFile(String fileName) async {
    try {
      return await rootBundle.loadString(fileName);
    } catch (e) {
      _logger.severe("Error reading asset file $fileName: ${e.toString()}");
      throw Exception("Failed to read asset file $fileName: ${e.toString()}");
    }
  }

  /// Read label encoder from a JSON file
  /// Returns a tuple of (encoder, decoder) maps
  static Future<Tuple2<Map<int, String>, Map<String, int>>>
      loadLabelEncoderAndDecoder() async {
    try {
      final jsonEncoderText = await _readFile(AssetPaths.labelEncoder);
      final jsonDecoderText = await _readFile(AssetPaths.labelDecoder);
      final jsonEncoderData =
          jsonDecode(jsonEncoderText) as Map<String, dynamic>;
      final jsonDecoderData =
          jsonDecode(jsonDecoderText) as Map<String, dynamic>;

      final encoder = <int, String>{};
      final decoder = <String, int>{};

      // Parse encoder JSON data
      jsonEncoderData.forEach((key, value) {
        final index = int.parse(key);
        final code = value.toString();
        encoder[index] = code;
      });

      // Parse decoder JSON data
      jsonDecoderData.forEach((key, value) {
        final code = key;
        final index = value;
        decoder[code] = index is int ? index : int.parse(index.toString());
      });

      _logger.info(
          "Loaded ${encoder.length} label encodings from ${AssetPaths.labelEncoder} and ${decoder.length} decodings from ${AssetPaths.labelDecoder}");
      return Tuple2(encoder, decoder);
    } catch (e) {
      _logger.severe("Error reading label encoder/decoder: ${e.toString()}");
      // Return empty maps if reading fails
      return Tuple2(<int, String>{}, <String, int>{});
    }
  }

  /// Read code frequencies from a JSON file
  /// Returns a map of code -> frequency
  static Future<Map<String, double>> loadCodeFrequencies() async {
    try {
      final jsonText = await _readFile(AssetPaths.codeFrequencies);
      final jsonData = jsonDecode(jsonText) as Map<String, dynamic>;

      final frequencies = <String, double>{};

      jsonData.forEach((code, value) {
        final frequency =
            value is double ? value : double.parse(value.toString());
        frequencies[code] = frequency;
      });

      _logger.info(
          "Loaded ${frequencies.length} code frequencies from ${AssetPaths.codeFrequencies}");
      return frequencies;
    } catch (e) {
      _logger.severe(
          "Error reading code frequencies from ${AssetPaths.codeFrequencies}: ${e.toString()}");
      // Return empty map if reading fails
      return <String, double>{};
    }
  }

  /// Read industry code descriptions from a JSON file
  /// Returns a map of code -> description
  static Future<Map<String, String>> loadIndustryCodeDataset() async {
    try {
      final descriptions = <String, String>{};
      final csvContent = await _readFile(AssetPaths.industryCodesDataset);
      final lines = csvContent.split('\n');

      // Skip header if present
      final startIndex =
          lines.isNotEmpty && lines[0].contains("MaNganh") ? 1 : 0;

      for (int i = startIndex; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // Split line by comma or semicolon
        final parts = line.contains(";") ? line.split(";") : line.split(",");

        if (parts.length >= 2) {
          // Get MaNganh (industry code) and TenVSIC (description)
          final maNganh = parts[0].trim().padLeft(5, '0'); // Pad with zeros
          final tenVSIC =
              parts[1].trim().replaceAll("\"", ""); // Remove any quotes
          descriptions[maNganh] = tenVSIC;
        }
      }

      _logger.info(
          "Loaded ${descriptions.length} code descriptions from ${AssetPaths.industryCodesDataset}");
      return descriptions;
    } catch (e) {
      _logger.severe(
          "Error reading code descriptions from ${AssetPaths.industryCodesDataset}: ${e.toString()}");
      // Return empty map if reading fails
      return <String, String>{};
    }
  }

  static Future<Map<String, dynamic>> loadModelConfig() async {
    try {
      final jsonText = await _readFile(AssetPaths.modelConfig);
      return jsonDecode(jsonText) as Map<String, dynamic>;
    } catch (e) {
      _logger.severe(
          "Error reading model config from ${AssetPaths.modelConfig}: ${e.toString()}");
      throw Exception(
          "Failed to read model config from ${AssetPaths.modelConfig}: ${e.toString()}");
    }
  }

  static Future<String> loadVocabulary() async {
    try {
      return await _readFile(AssetPaths.vocabulary);
    } catch (e) {
      _logger.severe(
          "Error reading vocab from ${AssetPaths.vocabulary}: ${e.toString()}");
      throw Exception(
          "Failed to read vocab from ${AssetPaths.vocabulary}: ${e.toString()}");
    }
  }

  static Future<String> loadBpe() async {
    try {
      return await _readFile(AssetPaths.bpe);
    } catch (e) {
      _logger.severe(
          "Error reading vocab from ${AssetPaths.bpe}: ${e.toString()}");
      throw Exception(
          "Failed to read vocab from ${AssetPaths.bpe}: ${e.toString()}");
    }
  }

  static Future<Uint8List> loadIndustryOnnxModel() async {
    final file = await localFile;
    final rawAssetFile = await file.readAsBytes();

    final bytes = rawAssetFile.buffer.asUint8List();
    return bytes;
  }

  // static Future<Uint8List> loadIndustryOnnxModel() async {
  //   final rawAssetFile = await rootBundle.load(AssetPaths.industryOnnxModel);
  //   final bytes = rawAssetFile.buffer.asUint8List();
  //   return bytes;
  // }

  static Future<String> get localPath async {
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = (await getApplicationDocumentsDirectory());
    }
    return directory.path;
  }

  static Future<File> get localFile async {
    final path = '${AppPref.dataModelAIFilePath}/${AppPref.dataModelAIVersionFileName}';//await localPath;
    debugPrint('Load from path $path');
       return File(path);
  //  return File('$path/models/model_v4.onnx');
  }
}
