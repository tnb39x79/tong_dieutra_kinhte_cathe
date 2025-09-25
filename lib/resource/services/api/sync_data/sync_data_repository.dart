import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';


class SyncRepository {
  SyncRepository({required this.provider});
  final SyncProvider provider;
 

  ///added by: tuannb 10/7/2024
  ///Thêm mới: syncDataV2 bắt timeout 60s khi gọi api , bắt exception;
  Future<ResponseModel<String>> syncDataV2(Map body,
      {Function(double)? uploadProgress}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    try {
      final data =
          await provider.syncDataV2(body, uploadProgress: uploadProgress);
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


  Future<ResponseToken<TokenModel>> getToken(
      {required String userName, required String password,String? iMei}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseToken.withDisconnect();
    }
    final body = {
      'grant_type': 'password',
      'username': userName,
      'password': password,
       'imei': iMei??''
    };

    final params = {'grant_type': 'refresh_token'};

    final response = await provider.getToken(params: params, body: body);

    String res= await response.stream.bytesToString();
    var decode = jsonDecode(res);

    if (response.statusCode == 200) {
      return ResponseToken(
        statusCode: response.statusCode,
        body: TokenModel.fromJson(decode),
      );
    } else {
      return ResponseToken.withError(decode);
    }
  }


  
}
