import 'dart:async';
import 'dart:convert';

import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/data_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/model_file_response_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/modelai_version_model.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class InputDataRepository {
  InputDataRepository({required this.provider});
  final InputDataProvider provider;

  Future<ResponseModel<DataModel>> getData() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    final data = await provider.getData();

    if (data.statusCode == ApiConstants.success) {
      return ResponseModel(
        statusCode: ApiConstants.success,
        body: DataModel.fromJson(data.body),
      );
    } else {
      return ResponseModel.withError(data);
    }
  }

  Future<ResponseModel<String>> getVersion() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    final data = await provider.getData();
    if (data.statusCode == ApiConstants.success) {
      return ResponseModel(
        statusCode: ApiConstants.success,
        body: jsonEncode(data.body),
      );
    } else {
      return ResponseModel.withError(data);
    }
  }

  Future<ResponseCmmModel<String>> getKyDieuTra() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseCmmModel.withDisconnect();
    }
    try {
      final data = await provider.getKyDieuTra();
      if (data.statusCode == ApiConstants.success) {
        return ResponseCmmModel(
          responseCode: data.statusCode.toString(),
          objectData: jsonEncode(data.body),
        );
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseCmmModel.withRequestTimeout();
      } else {
        return ResponseCmmModel.withError(data);
      }
    } on TimeoutException catch (_) {
      return ResponseCmmModel.withRequestTimeout();
    } catch (e) {
      return ResponseCmmModel.withRequestException(e);
    }
  }

  Future<ResponseCmmModel<String>> getCheckVersion() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseCmmModel.withDisconnect();
    }
    try {
      final data = await provider.getCheckVersion();
      if (data.statusCode == ApiConstants.success) {
        return ResponseCmmModel(
          responseCode: ApiConstants.responseSuccess,
          objectData: jsonEncode(data.body),
        );
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseCmmModel.withRequestTimeout();
      } else {
        return ResponseCmmModel.withError(data);
      }
    } on TimeoutException catch (_) {
      return ResponseCmmModel.withRequestTimeout();
    } catch (e) {
      return ResponseCmmModel.withRequestException(e);
    }
  }

  Future<ResponseCmmModel<ModelAIVersionModel>> getModelVersion() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseCmmModel.withDisconnect();
    }
    try {
      final data = await provider.getModelVersion();
      if (data.statusCode == ApiConstants.success) {
        var res = ResponseCmmModel.fromJson(data.body);
        ModelAIVersionModel dm = ModelAIVersionModel.fromJson(res.objectData);
        return ResponseCmmModel(
          responseCode: res.responseCode,
          responseMessage: res.responseMessage,
          objectData: dm,
        );
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseCmmModel.withRequestTimeout();
      } else {
        return ResponseCmmModel.withError(data);
      }
    } on TimeoutException catch (_) {
      return ResponseCmmModel.withRequestTimeout();
    } catch (e) {
      return ResponseCmmModel.withRequestException(e);
    }
  }

  Future<ResponseModel<ModelAIVersionModel?>> getModelSpeech() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    final data = await provider.getModelSpeech();
    if (data.statusCode == ApiConstants.success) {
      return ResponseModel(
        statusCode: ApiConstants.success,
        body: ModelAIVersionModel.fromJson(data.body['ObjectData']),
      );
    }
    return ResponseModel.withError(data.body);
  }


  /// Get model file information including download URLs and filenames
  /// API Endpoint: GET api/GetModelFile?uid=D990030018
  /// Returns ModelFileResponseModel with VCPA and STT model URLs and filenames
  Future<ResponseModel<ModelFileResponseModel>> getModelFile(String uid) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
   
    return provider.getModelFile(uid);
  }
}
