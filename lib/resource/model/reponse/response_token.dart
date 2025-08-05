import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart'; 

class ResponseToken<T> {
  int? statusCode;
  String? error;
  String? errorDescription;
  T? body;

  ResponseToken(
      {this.statusCode, this.error, this.errorDescription, this.body});

  ResponseToken.withError(dynamic response) {
    String error;
    String errorDescription;
    log("=========== ERROR ===========");
    if (response != null) {
      log("=========== data ===========");
      error = response['error'] ?? response;
      errorDescription = response['error_description'] ?? '';
    } else {
      statusCode = ApiConstants.errorServer;
      log("=========== message ===========");
      errorDescription = "Không thể kết nối đến máy chủ!";
      error = '';
    }
    this.error = error;
    this.errorDescription = errorDescription;
    body = null;
  }

  ResponseToken.withDisconnect() {
    log("=========== DISCONNECT ===========");
    errorDescription = "not_connect_internet".tr;
    statusCode = ApiConstants.errorDisconnect;
    body = null;
  }

 ResponseToken.withRequestTimeout() {
    log("=========== Timeout ===========");
    statusCode = HttpStatus.requestTimeout;
    errorDescription = "Request timeout";
    body = null;
  }

  bool get isSuccess => statusCode == ApiConstants.success ? true : false;
}
