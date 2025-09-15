import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_pref.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

import 'package:http/http.dart' as http;

class AuthProvider extends BaseProvider {
  /// Get token
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

    var request = http.Request(
        'POST', Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getToken}'));
    request.headers.addAll(headers);
    request.followRedirects = false;
    request.bodyFields = body;

    http.StreamedResponse response = await request.send();

    return response;
  }

  /// Get token
  Future<http.StreamedResponse> getExtraToken({
    required Map<String, String> params,
    required Map<String, String> body,
    required String url,
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

    var request =
        http.Request('POST', Uri.parse('$url${ApiConstants.getToken}'));
    request.headers.addAll(headers);
    request.followRedirects = false;
    request.bodyFields = body;

    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<Response> getUser(String uid) async {
    var result= await get('${ApiConstants.getUser}?uid=$uid');
    return result;
     
  }

  Future<Response> updateUser({
    required String uid,
    required Map<String, dynamic> body,
  }) async {
    return put('${ApiConstants.getUser}?uid=$uid', body);
  }

  Future<Response> changePassword({required String uid, required body}) async {
    //  String url='${ApiConstants.baseUrl}${ApiConstants.changePassword}?uid=$uid';
    var result = await put('${ApiConstants.changePassword}?uid=$uid', body);
    return result;
  }
}
