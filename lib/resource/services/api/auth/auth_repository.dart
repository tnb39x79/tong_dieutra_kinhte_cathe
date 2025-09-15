import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_udid/flutter_udid.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

import 'auth.dart';

class AuthRepository {
  AuthRepository({required this.provider});
  final AuthProvider provider;

  // base token
  Future<ResponseToken<TokenModel>> getToken(
      {required String userName, required String password}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseToken.withDisconnect();
    }
    final _mobileDeviceIdentifier = await FlutterUdid.udid;
    final body = {
      'grant_type': 'password',
      'username': userName,
      'password': password,
      "imei": _mobileDeviceIdentifier,
    };

    final params = {'grant_type': 'refresh_token'};
    try {
      final response = await provider.getToken(params: params, body: body);

      String response0 = await response.stream.bytesToString();
      var decode = jsonDecode(response0);
      log('decode: $response0');

      if (response.statusCode == 200) {
        return ResponseToken(
          statusCode: response.statusCode,
          body: TokenModel.fromJson(decode),
        );
      } else {
        return ResponseToken.withError(decode);
      }
    } catch (e) {
      if (e is TimeoutException) {
        log('Time out TimeoutException');
        return ResponseToken.withRequestTimeout();
      } else if (e is SocketException) {
        log('socket exception');
        return ResponseToken.withError(null);
      } else {
        log('exception $e');
        return ResponseToken.withError(null);
      }
    }
  }

  // get extra token user for sync data
  Future<ResponseToken<TokenModel>> getExtraToken(
      {required String userName,
      required String password,
      required url,
      String? iMei}) async {
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

    final response =
        await provider.getExtraToken(params: params, body: body, url: url);

    String response0 = await response.stream.bytesToString();
    var decode = jsonDecode(response0);
    log('decode: $response0');

    if (response.statusCode == 200) {
      return ResponseToken(
        statusCode: response.statusCode,
        body: TokenModel.fromJson(decode),
      );
    } else {
      return ResponseToken.withError(decode);
    }
  }

  Future<ResponseModel<UserModel>> getUser() async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    var uid = AppPref.uid;
    final response = await provider.getUser(uid!);
    if (response.statusCode == ApiConstants.success) {
      return ResponseModel(
        body: UserModel.fromJson(response.body),
        statusCode: response.statusCode,
      );
    } else {
      return ResponseModel.withError(response);
    }
  }

  Future<bool> updateUser(String uid, Map<String, dynamic> body) async {
    if (NetworkService.connectionType == Network.none) {
      return false;
    }
    final data = await provider.updateUser(uid: uid, body: body);
    log('status code: ${data.statusCode}');
    if (data.isOk) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePassword(String uid, Map<String, dynamic> body) async {
    if (NetworkService.connectionType == Network.none) {
      return false;
    }

    try {
      final data = await provider.changePassword(uid: uid, body: body);
      log('status code: ${data.statusCode}');
      if (data.statusCode == ApiConstants.success) {
        //  var res = jsonEncode(data.body);
        if (data.body["ResponseCode"] == ApiConstants.responseSuccess) {
          return true;
        } else {
          return false;
        }
        // return ResponseCmmModel(
        //   responseCode: data.statusCode.toString(),
        //   objectData: jsonEncode(data.body),
        // );
      } else {
        return false;
      }
    } on TimeoutException catch (_) {
      //return ResponseCmmModel.withRequestTimeout();
    } catch (e) {
      // return ResponseCmmModel.withRequestException(e);
    }
    return false;
  }
}
