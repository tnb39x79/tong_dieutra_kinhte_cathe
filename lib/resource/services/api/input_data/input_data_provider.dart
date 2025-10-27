import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/model/reponse/model_file_response_model.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class InputDataProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 60); // default timeout = 8 s,
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }

  Future<Response> getData() async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    String versionDm = AppPref.versionDanhMuc == ""
        ? AppValues.versionDanhMuc
        : AppPref.versionDanhMuc;
    try {
      String urlGet =
          'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.getData}?uid=${AppPref.uid}&versionApp=${AppValues.versionApp}&versionDm=$versionDm';

      // return get(
      //   'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.getData}?uid=${AppPref.uid}&versionApp=${AppValues.versionApp}&versionDm=$versionDm',
      //   headers: headers,
      // );
      var response = await get(
        urlGet,
        headers: headers,
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> getKyDieuTra() async {
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    httpClient.timeout = const Duration(seconds: 15);
    String urlKdt =
        '${ApiConstants.baseUrl}${ApiConstants.getKyDieuTra}?uid=${AppPref.uid}';
    try {
      var response = await get(
        urlKdt,
        headers: headers,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> getCheckVersion() async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    httpClient.timeout = const Duration(seconds: 15);
    String urlGetVersion =
        'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.getCheckVersion}?uid=${AppPref.uid}&versionApp=${AppValues.versionApp}';
    try {
      var response = await get(
        urlGetVersion,
        headers: headers,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> getModelVersion() async {
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    httpClient.timeout = const Duration(seconds: 15);
    String modelUrl =
        '${ApiConstants.baseUrl}${ApiConstants.getModelVersion}?uid=${AppPref.uid}&mVersion=${AppPref.dataModelAIVersionFileName}';
    try {
      var response = await get(
        modelUrl,
        headers: headers,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> getModelSpeech() async {
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    httpClient.timeout = const Duration(seconds: 15);
  //  final baseUrl = ApiConstants.baseUrl.split('://').last.replaceAll("/", "");
    String modelUrl =
        '${ApiConstants.baseUrl}${ApiConstants.getModelSpeech}?uid=${AppPref.uid}&versionApp=${AppValues.versionApp}';
    try {
      var response = await get(
        modelUrl,
        headers: headers,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  /// Get model file information including download URLs and filenames
  /// API Endpoint: GET api/GetModelFile?uid=D990030018
  /// Returns ModelFileResponseModel with VCPA and STT model URLs and filenames
  Future<ResponseModel<ModelFileResponseModel>> getModelFile(String uid) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    //final baseUrl = ApiConstants.baseUrl.split('://').last.replaceAll("/", "");
    String modelUrl = '${ApiConstants.baseUrl}${ApiConstants.getModelFile}?uid=${AppPref.uid}';

    final res = await get(modelUrl);
    if (res.statusCode == ApiConstants.success) {
      return ResponseModel(
        statusCode: ApiConstants.success,
        body: ModelFileResponseModel.fromJson(res.body['ObjectData']),
      );
    }
    return ResponseModel.withError(res.body);
  }
}
