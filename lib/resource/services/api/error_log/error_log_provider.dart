import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class ErrorLogProvider extends GetConnect {
  ///added by: tuannb 10/09/2024
  ///Thêm mới chức năng gửi lỗi cho các chức năng PV;
  Future<Response> sendErrorLog(ErrorLogModel errorLogModel,
      {Function(double)? uploadProgress}) async {
    String loginData = AppPref.loginData;
    TokenModel model = loginData.isNotEmpty
        ? TokenModel.fromJson(jsonDecode(loginData))
        : TokenModel();
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };
    httpClient.timeout = const Duration(seconds: 15);
    String url =
        'http://${model.domainAPI}:${model.portAPI}/${ApiConstants.sendErrorLog}';

    log('HEADER: $headers');
    log('url: $url');
    try {
      var response = await post(
        url,
        errorLogModel,
        uploadProgress: uploadProgress,
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
      // error
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }
 
}