import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_widget.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_module.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_result.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';

///Viết lại dựa theo sync_module của chăn nuôi version 2.1.1 ngày ....
class SyncController extends BaseController with SyncMixin {
  SyncController(
      {required this.syncRepository, required this.sendErrorRepository});

  final SyncRepository syncRepository;

  ///added by tuannb: Sử dụng cho hàm gửi datajson khi đồng bộ phát sinh lỗi
  final SendErrorRepository sendErrorRepository;

  final MainMenuController mainMenuController = Get.find();

  final bKCoSoSXKDProvider = BKCoSoSXKDProvider(); 
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();

  final danhSachBKCoSoSXKDInterviewed = <TableBkCoSoSXKD>[].obs; 

  final progress = 0.0.obs;
  final endSync = false.obs;

  /// Sử dụng cho hàm gửi datajson khi đồng bộ phát sinh lỗi
  final responseMessage = ''.obs;
  final responseCode = ''.obs;
  final syncResults = <SyncResult>[].obs;  

  @override
  void onInit() {
    syncData();
    super.onInit();
  }

  Future syncData() async {
    resetVarBeforeSync();
    endSync(false);
    await getData();
    var resSync =
        await uploadDataMixin(syncRepository, sendErrorRepository, progress);
    responseCode.value = resSync.responseCode ?? '';
    if (resSync.responseCode == ApiConstants.responseSuccess) {
      responseMessage.value = resSync.responseMessage ?? "Đồng bộ thành công.";

      if (resSync.syncResults != null && resSync.syncResults!.isNotEmpty) {
        syncResults.assignAll(resSync.syncResults!); 
      }
    } else {
      responseMessage.value = resSync.responseMessage ?? "Đồng bộ lỗi.";
    }

    endSync(true);
  }

  resetVarBeforeSync() {
    progress.value = 0.0;
    responseCode.value = '';
    responseMessage.value = '';
    endSync(false);
  }
 

  void backHome() {
    Get.back();
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
