import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:http/http.dart' as http;

class SyncProvider extends GetConnect {
  @override
  void onInit() {
    allowAutoSignedCert = true;
    httpClient.timeout = const Duration(seconds: 60);
  }
  // @override
  // void onInit() {
  //   httpClient.timeout = const Duration(seconds: 20); // default timeout = 8 s,
  //   httpClient.addAuthenticator(authInterceptor);
  //   httpClient.addResponseModifier(responseInterceptor);
  // }

  ///added by: tuannb 10/7/2024
  ///Thêm mới: syncDataV2 thông báo khi gọi api bị timeout;
  Future<Response> syncDataV2(Map body,
      {Function(double)? uploadProgress}) async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };
    String hp = AppUtils.getHttpOrHttps(loginData.portAPI ?? '');
    // String url =  '$hp://${loginData.domainAPI}/${ApiConstants.sync}';
    httpClient.baseUrl = '$hp://${loginData.domainAPI}/';
    log('HEADER: $headers');
    log('syncDataV2 httpClient.baseUrl action: ${httpClient.baseUrl}${ApiConstants.sync}');
    try {
      var response = await post(
        ApiConstants.sync,
        body,
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
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

  Future<http.StreamedResponse> getToken({
    required Map<String, String> params,
    required Map<String, String> body,
  }) async {
    String credentials =
        "${ApiConstants.basicUserName}:${ApiConstants.basicPass}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);

    //header
    var headers = {
      'Authorization': 'Basic $encoded',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    String loginData = AppPref.loginData;
    TokenModel model = loginData.isNotEmpty
        ? TokenModel.fromJson(jsonDecode(loginData))
        : TokenModel();
    String hp = AppUtils.getHttpOrHttps(model.portAPI ?? '');
    var request = http.Request('POST',
        Uri.parse('${'$hp://${model.domainAPI}/'}${ApiConstants.getToken}'));
    request.headers.addAll(headers);
    request.followRedirects = false;
    request.bodyFields = body;

    http.StreamedResponse response = await request.send();

    return response;
  }
}
