import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';

class ResponseModel<T> {
  int? statusCode;
  String? message;
  String? responseCode;
  T? body;

  ResponseModel({this.statusCode, this.body});

  ResponseModel.withDefault({this.statusCode,this.body,this.responseCode}); 

  ResponseModel.withError(Response? response) {
    String? message;
    int? statusCode;
    log("=========== ERROR ===========");
    if (response != null) {
      log("=========== statusCode ===========");
      log("${response.statusCode}");
      statusCode = response.statusCode;
      log("=========== data ===========");
      log("${response.body}");
      message = '';
      // message = response.body['Message']?? response.body;
       if (statusCode == null) {
        if (response.statusText != null && response.statusText != "") {
          message = response.statusText;
        }
      }
    } else {
      statusCode = ApiConstants.errorServer;
      log("=========== message ===========");
      message = "Không thể kết nối đến máy chủ!";
    }
    this.message = message;
    this.statusCode = statusCode;
    body = null;
  }

  ///added by: tuannb 10/7/2024: Lấy thêm chuỗi message lỗi trả về từ response
  ResponseModel.withErrorV2(Response? response) {
    String? message;
    int? statusCode;
    log("=========== ERROR ===========");
    if (response != null) {
      log("=========== statusCode ===========");
      log("${response.statusCode}");
      statusCode = response.statusCode;
      log("=========== data ===========");
      log("${response.body}");
      log("${response.bodyString}");
      message = response.bodyString ?? '';
      // message = response.body['Message']?? response.body;
       if (statusCode == null) {
        if (response.statusText != null && response.statusText != "") {
          message = response.statusText;
        }
      }
    } else {
      statusCode = ApiConstants.errorServer;
      log("=========== message ===========");
      message = "Không thể kết nối đến máy chủ!";
    }
    this.message = message;
    this.statusCode = statusCode;
    body = null;
  }

  ResponseModel.withDisconnect() {
    log("=========== DISCONNECT ===========");
    message = "Disconnect";
    statusCode = ApiConstants.errorDisconnect;
    body = null;
  }

  ///added by: tuannb 10/7/2024
  ///Thêm mới: withRequestTimeout thông báo khi gọi api bị timeout;
  ResponseModel.withRequestTimeout() {
    log("=========== Timeout ===========");
    message = "Request timeout";
    statusCode = HttpStatus.requestTimeout;
    body = null;
  }

  ///added by: tuannb 10/7/2024
  ///Thêm mới: withRequestException thông báo khi gọi api bị exception;
  ResponseModel.withRequestException(e) {
    log("=========== Request Exception ===========");
    message = "Lỗi: $e";
    statusCode = ApiConstants.errorException;
    body = null;
  }

  bool get isSuccess => statusCode == ApiConstants.success ? true : false;
}
