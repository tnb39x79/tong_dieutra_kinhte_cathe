import 'dart:async';
import 'dart:developer' as develop;
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/modelai_version_model.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/download_task/download_task_service.dart';

import 'package:gov_statistics_investigation_economic/resource/services/network_service/network_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadModelAIController extends BaseController {
  final HomeController homeController = Get.find();
  NetworkService networkServiceStatus = Get.find();
  final httpClient = http.Client();
  String filePath = '';
  final totalBytes = 0.obs, receivedBytes = 0.obs, responseMsg = ''.obs;
  final downloadProgressNotifier = 0.obs;
  final downloadStartNotifier = false.obs;
  final downloadingNotifier = false.obs;
  final messageResult = ''.obs;
  final messageResultCode = ''.obs;
  late final DownloadTaskService downloadTaskService;
  @override
  void onInit() async {
    super.onInit();
    if (NetworkService.connectionType == Network.none) {
      messageResult.value = 'no_connect_internet'.tr;
    } else {
      messageResult.value = '';
    }
    await downloadModelAIV2();
  }

  Future downloadModelAIV2() async {
    downloadProgressNotifier.value = 0;
    receivedBytes.value = 0;
    totalBytes.value = 0;
    AppPref.dataModelDownResult = 'failed';
    if (NetworkService.connectionType == Network.none) {
      downloadStartNotifier.value = false;
      messageResultCode.value = ApiConstants.errorDisconnect.toString();
      messageResult.value = 'no_connect_internet'.tr;
    } else {
      downloadStartNotifier.value = true;
      messageResultCode.value = '';
      messageResult.value = '';
      ModelAIVersionModel?
          modelAIVersionModel; //= ModelAIVersionModel(id: 0;modelFileUrl: "",version: "");
      //Lấy thông tin phiên bản Model AI
      var mVersion = await homeController.inputDataRepository.getModelVersion();
      if (mVersion.responseCode == ApiConstants.responseSuccess) {
        modelAIVersionModel = mVersion.objectData;
      } else if (mVersion.responseCode == ApiConstants.modelAILastestVersion) {
        messageResultCode.value = ApiConstants.responseSuccess;
        messageResult.value = 'Bạn đang dùng phiên bản Model AI mới nhất.';
        return;
      } else {
        messageResultCode.value =
            mVersion.responseCode ?? ApiConstants.errorException.toString();
        messageResult.value = mVersion.responseMessage ??
            'Có lỗi lấy thông tin phiên bản Model AI';
        return;
      }
      if (modelAIVersionModel == null) {
        messageResult.value = mVersion.responseMessage ??
            'Không lấy thông tin phiên bản Model AI. Vui lòng thử lại.';
        return;
      }
      // String urlModelFile =
      //     'https://drive.usercontent.google.com/download?id=1xhPTR3hqhNMF0gz49q37yv2QlKdzFkvq&export=download&authuser=0&confirm=t&uuid=e9983292-eb3c-4a7d-a648-bb978e36f1b0&at=AEz70l50bcoIGgxerJcdPpfJHsup%3A1742440050412';
      // String urlModelFile =
      //     'https://drive.usercontent.google.com/download?id=1xhPTR3hqhNMF0gz49q37yv2QlKdzFkvq&export=download&authuser=0&confirm=t&uuid=e9983292-eb3c-4a7d-a648-bb978e36f1b0&at=AEz70l50bcoIGgxerJcdPpfJHsup%3A1742440050412';
      String urlModelFile = modelAIVersionModel.modelFileUrl!;
      String fileNameOnnx = modelAIVersionModel.version!; // 'model_v3.onnx';
      final currentFilePath = '${AppPref.dataModelAIFilePath}/$fileNameOnnx';
      final currentFile = File(currentFilePath);
      var isCurrentFileExist = await currentFile.exists();
      if (isCurrentFileExist) {
        messageResultCode.value = ApiConstants.responseSuccess;
        messageResult.value = 'Bạn đang dùng phiên bản Model AI mới nhất.';
        return;
      }
      String modelsDir = 'models';

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
        // initialize download request
        downloadTaskService = await DownloadTaskService.download(
            Uri.parse(urlModelFile),
            file: file,
            client: httpClient);
        // listen to state changes
        double previousProgress = 0.0;
        downloadTaskService.events.listen((event) {
          switch (event.state) {
            case TaskState.downloading:
              downloadingNotifier.value = true;
              final bytesReceived = event.bytesReceived!;
              final totalAllBytes = event.totalBytes!;
              if (totalAllBytes == -1) return;

              final progress =
                  (bytesReceived / totalAllBytes * 100).floorToDouble();
              downloadProgressNotifier.value = progress.round();
              receivedBytes.value = bytesReceived;
              totalBytes.value = totalAllBytes;

              if (progress != previousProgress && progress % 10 == 0) {
                print("progress $progress%");
                previousProgress = progress;
              }
              break;
            case TaskState.paused:
              downloadingNotifier.value = false;
              print("paused");
              break;
            case TaskState.success:
              downloadingNotifier.value = false;
              print("downloaded");
              AppPref.dataModelAIFilePath = dirPath;
              AppPref.dataModelAIVersionFileName = fileNameOnnx;
              AppPref.dataModelDownResult = 'ok';
              messageResultCode.value = ApiConstants.responseSuccess;
              messageResult.value = 'Đã tải hoàn thành.';
              break;
            case TaskState.canceled:
              downloadingNotifier.value = false;
              print("canceled");
              break;
            case TaskState.error:
              downloadingNotifier.value = false;
              messageResultCode.value = ApiConstants.errorException.toString();
              messageResult.value = 'Có lỗi: ${event.error!}';
              print("error: ${event.error!}");
              break;
          }
        });
      } catch (e) {
        // Error in getting access to the file.
        messageResultCode.value = ApiConstants.errorException.toString();
        messageResult.value = 'Có lỗi: $e';
      }
    }
  }

  downloadPause() async {
    await downloadTaskService.pause();
  }

  downloadResume() async {
    await downloadTaskService.resume();
  }

  downloadCancel() async {
    await downloadTaskService.cancel();
  }

  Future<String> createFolder(String cow) async {
    final dir = Directory(
        '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationDocumentsDirectory() //FOR IOS
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
    await downloadCancel();
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
    try {} catch (e) {
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
    try {} catch (e) {
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
