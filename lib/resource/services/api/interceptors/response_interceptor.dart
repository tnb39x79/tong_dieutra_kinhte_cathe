import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

FutureOr<dynamic> responseInterceptor(
    Request request, Response response) async {
  // log('body: ${response.body}');
  log('url: ${request.url}');
  log('header: ${request.headers}');
  return response;
}
