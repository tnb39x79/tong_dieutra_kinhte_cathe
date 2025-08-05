import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';

class ResponseCmmModel<T> {
  String? responseCode;
  String? responseMessage;
  T? objectData;

  ResponseCmmModel({
    this.responseCode,
    this.responseMessage,
    this.objectData,
  });

  ResponseCmmModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];
    objectData = json['ObjectData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;
    data['ObjectData'] = objectData;
    return data;
  }

  ResponseCmmModel.withDisconnect() {
    log("=========== DISCONNECT ===========");
    responseMessage = "Disconnect";
    responseCode = ApiConstants.errorDisconnect.toString();
    objectData = null;
  }

  ResponseCmmModel.withError(Response? response) {
    String? message;
    int? statusCode;
    log("=========== ERROR ===========");
    if (response != null) {
      log("=========== statusCode ===========");
      log("${response.statusCode}");
      statusCode = response.statusCode;
      log("=========== data ===========");
      log("${response.body}");
      message = response.bodyString ?? '';
      String message2 = '';
      message2 = response.statusText ?? '';
      message = message ?? message2;
    } else {
      statusCode = ApiConstants.errorServer;
      log("=========== message ===========");
      message = "Không thể kết nối đến máy chủ!";
    }
    responseMessage = message;
    responseCode = statusCode.toString();
    objectData = null;
  }

  ///
  /// withRequestTimeout thông báo khi gọi api bị timeout;
  ResponseCmmModel.withRequestTimeout() {
    log("=========== Timeout ===========");
    responseCode = HttpStatus.requestTimeout.toString();
    responseMessage = "Request timeout";
    objectData = null;
  }

  /// withRequestException thông báo khi gọi api bị exception;
  ResponseCmmModel.withRequestException(e) {
    log("=========== Request Exception ===========");
    responseCode = ApiConstants.errorException.toString();
    responseMessage = "Lỗi: $e";
    objectData = null;
  }
}
