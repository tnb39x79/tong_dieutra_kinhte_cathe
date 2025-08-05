import 'dart:async';
import 'dart:developer' as develop;
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gov_statistics_investigation_economic/resource/services/network_service/network_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadModelAIOldController extends BaseController {
  NetworkService networkServiceStatus = Get.find();
  final httpClient = http.Client();
  late IOSink sink;
  String filePath = '';
  final totalBytes = 0.obs, receivedBytes = 0.obs, responseMsg = ''.obs;
  final downloadProgressNotifier = 0.obs;
  final downloadStartNotifier = false.obs;
  

  @override
  void onInit() async {
    super.onInit();
    //networkServiceStatus.onInit();

    await downloadModelAIV2();
  }

  executeDownload() async {
    await downloadModelAIV2();
  }

  stopDownload() async {
    resetDownload();
  }
   
  Future downloadModelAIV2() async {
    downloadProgressNotifier.value = 0;
    receivedBytes.value = 0;
    totalBytes.value = 0;

    if (NetworkService.connectionType == Network.none) {
    } else {
      String urlModelFile =
          'https://drive.usercontent.google.com/download?id=1xhPTR3hqhNMF0gz49q37yv2QlKdzFkvq&export=download&authuser=0&confirm=t&uuid=e9983292-eb3c-4a7d-a648-bb978e36f1b0&at=AEz70l50bcoIGgxerJcdPpfJHsup%3A1742440050412';
      String modelsDir = 'models';
      String fileNameOnnx = 'model_v4.onnx';
      downloadProgressNotifier.value = 0;
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!;
      } else {
        directory = (await getApplicationDocumentsDirectory());
      }
      var dirPath = await createFolder(modelsDir);
      try {
        final dir = Directory(dirPath);
        final List<FileSystemEntity> files = dir.listSync();
        for (final FileSystemEntity file in files) {
          await file.delete();
        }
      } catch (e) {
        // Error in getting access to the file.
      }
      filePath = '$dirPath/$fileNameOnnx';

      print('filePath $filePath');
      final file = File(filePath);
      try {
        await downloadFile(file.path, urlModelFile, onProgress: (bytes, total) {
          if (total != null) {
            receivedBytes.value = bytes;
            totalBytes.value = total;
            downloadProgressNotifier.value = (100 * (bytes / total)).round();
          }
        });
        AppPref.dataModelAIFilePath = filePath;
        downloadStartNotifier.value = true;
      } catch (e) {
        // Error in getting access to the file.
      }
    }
  }

  Future<void> downloadFile(
    String filePath,
    url, {
    void Function(int, int?)? onProgress,
  }) async {
    sink = File(filePath).openWrite();

    var request = http.Request('GET', Uri.parse(url));
    final response = await httpClient.send(request);
    var startTime = DateTime.timestamp();
    if (onProgress == null) {
      await sink.addStream(response.stream);
    } else {
      var bytes = 0;

      await sink.addStream(response.stream.map((e) {
        bytes += e.length;
        onProgress(bytes, response.contentLength);
        return e;
      }));

      print(
          'Downloaded $bytes bytes in ${DateTime.timestamp().difference(startTime).inMilliseconds}ms');
    }
    await sink.flush();
    await sink.close();
  }

  Future<String> createFolder(String cow) async {
    final dir = Directory(
        '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationSupportDirectory() //FOR IOS
            )!.path}/$cow');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create();
      return dir.path;
    }
  }

  Future onBackHome() async {
    backHome();
  }

  void backHome() {
    resetDownload();
    Get.back();
  }

  resetDownload() {
    downloadProgressNotifier.value = 0;
    receivedBytes.value = 0;
    totalBytes.value = 0;
    filePath = '';
    try {
      sink.close();
    } catch (e) {
      debugPrint('sink close is error: $e');
    }
    try {
      httpClient.close();
    } catch (e) {
      debugPrint('httpClient close is error: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      sink.close();
    } catch (e) {
      debugPrint('sink close is error: $e');
    }
    try {
      httpClient.close();
    } catch (e) {
      debugPrint('httpClient close is error: $e');
    }
    super.dispose();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
