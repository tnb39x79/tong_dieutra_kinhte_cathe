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
class SyncControllerV2 extends BaseController with StateMixin, SyncMixinV2 {
  SyncControllerV2(
      {required this.syncRepository, required this.sendErrorRepository});

  final SyncRepository syncRepository;

  ///added by tuannb: Sử dụng cho hàm gửi datajson khi đồng bộ phát sinh lỗi
  final SendErrorRepository sendErrorRepository;

  final bKCoSoSXKDProvider = BKCoSoSXKDProvider();
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();

  final progress = 0.0.obs;
  final endSync = false.obs;

  /// Sử dụng cho hàm gửi datajson khi đồng bộ phát sinh lỗi
  final responseMessage = ''.obs;
  final responseCode = ''.obs;
  final syncResults = <SyncResult>[].obs;
  final isSyncing = false.obs;
  final isSyncCompleted = false.obs;
  final isNetworkStatus = false.obs;
  final networkService = Get.find<NetworkService>();

  @override
  void onInit() async {
    super.onInit();
    await getData();
    ever(networkService.connectionTypeObservable, (Network connectionType) {
      if (connectionType == Network.none) {
        isNetworkStatus.value = false;
      } else {
        isNetworkStatus.value = true;
      }
    });
  }

  Future<List<TableBkCoSoSXKDSync>> getData() async {
    change(null, status: RxStatus.loading());
    await getListInterviewed();
    change(null, status: RxStatus.success());
    return danhSachBkCoSoSXKDInterviewed.value;
  }

  Future syncSingleData() async {
    resetVarBeforeSingleSync();
    isSyncing.value = true;
    await syncData();
  }

  Future syncData() async {
    resetVarBeforeSync();
    responseMessage.value = '';
    responseCode.value = '';
    syncResults.value = [];

    msgBundleBody = {};
    int pageNumber = 1;
    int pageSize = 5;
    if (danhSachBkCoSoSXKDInterviewed.isNotEmpty) {
      int totalRecord = danhSachBkCoSoSXKDInterviewed.length;

      var totalPages_pre = (totalRecord / pageSize);
      var totalPages = totalPages_pre.ceil();

      for (var i = 1; i <= totalPages; i++) {
        pageNumber = i;
        await getListInterviewedPaginatedSync(pageNumber, pageSize);
        if (danhSachBkCoSoSXKDInterviewedPagingated.isNotEmpty) {
          Map mBody = await getBundleCoSoSX();
          await setSyncingBkCoSo(1, 'Đang đồng bộ...');
          await Future.delayed(const Duration(seconds: 2));

          var resSync = await syncSingleMixin(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false, isSendFullDataError: false);
          await Future.delayed(const Duration(seconds: 2));
          if (resSync.responseCode == ApiConstants.responseSuccess) {
            responseMessage.value += resSync.responseMessage ?? '';
            if (resSync.syncResults != null &&
                resSync.syncResults!.isNotEmpty) {
              syncResults.clear();
              syncResults.assignAll(resSync.syncResults!);
            } else {}
            if (resSync.syncResultDetailItems != null &&
                resSync.syncResultDetailItems!.isNotEmpty) {
              for (var itemRes in resSync.syncResultDetailItems!) {
                int resCode = itemRes.isSuccess ?? 3;
                if (itemRes.isSuccess != null) {
                  if (itemRes.isSuccess == 1) {
                    resCode = 2;
                  } else if (itemRes.isSuccess == 0) {
                    resCode = 3;
                  }
                }
                updateListBkCoSoSync(
                    itemRes.id!, resCode, itemRes.errorMessage ?? '');
              }
            } else {
              for (var item in danhSachBkCoSoSXKDInterviewed) {
                String message = resSync.responseMessage ?? "Đồng bộ lỗi.";
                item.isSyncSuccess = 3;
                updateListBkCoSoSync(item.iDCoSo!, 3, message);
              }
              // danhSachBkCoSoSXKDInterviewed.refresh();
            }
          } else {
            responseMessage.value += resSync.responseMessage ?? "Đồng bộ lỗi.";
            String message = resSync.responseMessage ?? "Đồng bộ lỗi.";
            for (var item in danhSachBkCoSoSXKDInterviewed) {
              item.isSyncSuccess = 3;
              // SyncResultSingleItem syncResult = SyncResultSingleItem(
              //     id: item.iDCoSo,
              //     ten: item.tenCoSo,
              //     maXa: item.maXa,
              //     maDiaBan: item.maDiaBan,
              //     resCode: 3,
              //     resMessage: message);
              // item.syncResult = syncResult;s
              updateListBkCoSoSync(item.iDCoSo!, 3, message);
            }
            //  danhSachBkCoSoSXKDInterviewed.refresh();
          }
        }
        await Future.delayed(const Duration(seconds: 2));
        isSyncing.value = false;
        isSyncCompleted.value = true;
      }
    }
  }

  Future setSyncingBkCoSo(int resCode, String resMessage) async {
    if (danhSachBkCoSoSXKDInterviewed.isNotEmpty) {
      List<TableBkCoSoSXKDSync> tblSync = danhSachBkCoSoSXKDInterviewed;
      if (danhSachBkCoSoSXKDInterviewedPagingated.isNotEmpty) {
        for (var item in danhSachBkCoSoSXKDInterviewedPagingated) {
          // SyncResultSingleItem syncResult = SyncResultSingleItem(
          //     id: item.iDCoSo,
          //     ten: item.tenCoSo,
          //     maXa: item.maXa,
          //     maDiaBan: item.maDiaBan,
          //     resCode: resCode,
          //     resMessage: resMessage);
          // itemBk.syncResult = syncResult;
          updateListBkCoSoSync(item.iDCoSo!, resCode, resMessage);
        }
      }
    }
    danhSachBkCoSoSXKDInterviewed.refresh();
  }

  updateListBkCoSoSync(String idCoSo, int resCode, String resMessage) {
    final index = danhSachBkCoSoSXKDInterviewed
        .indexWhere((element) => element.iDCoSo == idCoSo);
    var syncResult = SyncResultSingleItem(
        id: idCoSo,
        ten: danhSachBkCoSoSXKDInterviewed[index].tenCoSo,
        maXa: danhSachBkCoSoSXKDInterviewed[index].maXa,
        maDiaBan: danhSachBkCoSoSXKDInterviewed[index].maDiaBan,
        resCode: resCode,
        resMessage: resMessage);
    if (index != -1) {
      update(danhSachBkCoSoSXKDInterviewed..[index].syncResult = syncResult);
    }
    danhSachBkCoSoSXKDInterviewed.refresh();
  }

  resetVarBeforeSync() {
    progress.value = 0.0;
    responseCode.value = '';
    responseMessage.value = '';
    endSync(false);
  }

  resetVarBeforeSingleSync() {
    progress.value = 0.0;
    responseCode.value = '';
    responseMessage.value = '';
    isSyncing.value = false;
    endSync(false);
  }

  void backHome() {
    resetVarBeforeSingleSync();

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
