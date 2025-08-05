import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

import 'send_error_provider.dart';

class SendErrorRepository {
  SendErrorRepository({required this.provider});
  final SendErrorProvider provider;

 

   ///added by: tuannb 11/7/2024
  ///Thêm mới chức năng gửi lỗi;
  Future<ResponseModel<String>> sendErrorData(Map body,
      {Function(double)? uploadProgress}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    try {
      final data =
          await provider.sendErrorData(body, uploadProgress: uploadProgress);
      if (data.statusCode == ApiConstants.success) {
        return ResponseModel(
          statusCode: ApiConstants.success,
          body: jsonEncode(data.body),
        );
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseModel.withRequestTimeout();
      } else {
        log('error: ${data.body}');
        return ResponseModel.withErrorV2(data);
      }
    } on TimeoutException catch (_) {
      return ResponseModel.withRequestTimeout();
    } catch (e) {
      return ResponseModel.withRequestException(e);
    }
  }
}
