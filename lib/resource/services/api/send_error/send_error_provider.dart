import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/file_model.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class SendErrorProvider extends GetConnect {
  @override
  void onInit() {
    allowAutoSignedCert = true;
    httpClient.timeout = const Duration(seconds: 60);
  }

  ///added by: tuannb 11/7/2024
  ///Thêm mới chức năng gửi lỗi;
  Future<Response> sendErrorData(Map body,
      {Function(double)? uploadProgress}) async {
    allowAutoSignedCert = true;
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };

    httpClient.timeout = const Duration(seconds: 40);
    String hp = AppUtils.getHttpOrHttps(loginData.portAPI ?? '');

    httpClient.baseUrl = '$hp://${loginData.domainAPI}/';
    log('HEADER: $headers');
    log('Url senderrordata: ${httpClient.baseUrl}${ApiConstants.sendErrorData}');
    try {
      var response = await post(
        ApiConstants.sendErrorData,
        body,
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 60),
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
      // error
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> getAllowSendFile() async {
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.accessToken}'
    };
    httpClient.timeout = const Duration(seconds: 15);
    String modelUrl =
        '${ApiConstants.baseUrl}${ApiConstants.getAllowSendFile}?uid=${AppPref.uid}';
    try {
      var response = get(
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

  Future<Response> sendFullData(FileModel body,
      {Function(double)? uploadProgress}) async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };

    httpClient.timeout = const Duration(seconds: 60);
    String hp = AppUtils.getHttpOrHttps(loginData.portAPI ?? '');
    String url = '$hp://${loginData.domainAPI}/${ApiConstants.sendFullData}';
    httpClient.baseUrl = '$hp://${loginData.domainAPI}/';
    log('HEADER: $headers');
    log('url: $url');
    try {
      var response = await post(
        ApiConstants.sendFullData,
        jsonEncode(body),
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 40),
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
      // error
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }
}
