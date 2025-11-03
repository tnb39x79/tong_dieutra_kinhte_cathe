import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/dialog_widget.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
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
    await getFullDataSync();
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

    int pageSize = AppPref.pageSizeSync ?? 5;

    if (danhSachBkCoSoSXKDInterviewed.isNotEmpty) {
      int totalRecord = danhSachBkCoSoSXKDInterviewed.length;

      var totalPages_pre = (totalRecord / pageSize);
      var totalPages = totalPages_pre.ceil();
     
      for (int i = 1; i <= totalPages; i++) {
        await getListInterviewedPaginatedSync(i, pageSize);
        await Future.delayed(const Duration(seconds: 1));

        if (danhSachBkCoSoSXKDInterviewedPagingated.isNotEmpty) {
          Map mBody = await getBundleCoSoSX();
          await setSyncingBkCoSo(1, 'Đang đồng bộ...');
          await Future.delayed(const Duration(seconds: 2));

          var resSync = await syncSingleMixin(
              syncRepository, sendErrorRepository, progress,
              isRetryWithSignIn: false, isSendFullDataError: false);
          await Future.delayed(const Duration(seconds: 2));
          if (resSync.responseCode == ApiConstants.responseSuccess) {
            // responseMessage.value += resSync.responseMessage ?? '';

            if (resSync.syncResults != null &&
                resSync.syncResults!.isNotEmpty) {
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
                await updateListBkCoSoSync(
                    itemRes.id!, resCode, itemRes.errorMessage ?? '',
                    isSynced: AppDefine.synced);
              }
            } else {
              for (var item in danhSachBkCoSoSXKDInterviewed) {
                String message = resSync.responseMessage ?? "Đồng bộ lỗi.";
                item.isSyncSuccess = 3;
                await updateListBkCoSoSync(item.iDCoSo!, 3, message,
                    isSynced: AppDefine.unSync);
              }
            }
          } else {
            //  responseMessage.value += resSync.responseMessage ?? "Đồng bộ lỗi.";
            String message = resSync.responseMessage ?? "Đồng bộ lỗi.";
            for (var item in danhSachBkCoSoSXKDInterviewed) {
              await updateListBkCoSoSync(item.iDCoSo!, 3, message,
                  isSynced: AppDefine.unSync);
            }
          }
        }
        // await Future.delayed(const Duration(seconds: 2));
      }
      await Future.delayed(const Duration(seconds: 1));
      isSyncing.value = false;
      isSyncCompleted.value = true;
      messageResultFinal();
    }
  }

  Future setSyncingBkCoSo(int resCode, String resMessage) async {
    if (danhSachBkCoSoSXKDInterviewed.isNotEmpty) {
      List<TableBkCoSoSXKDSync> tblSync = danhSachBkCoSoSXKDInterviewed;
      if (danhSachBkCoSoSXKDInterviewedPagingated.isNotEmpty) {
        for (var item in danhSachBkCoSoSXKDInterviewedPagingated) {
          await updateListBkCoSoSync(item.iDCoSo!, resCode, resMessage);
        }
      }
    }
    danhSachBkCoSoSXKDInterviewed.refresh();
  }

  updateListBkCoSoSync(String idCoSo, int resCode, String resMessage,
      {int? isSynced}) async {
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
      if (isSynced != null) {
        update(danhSachBkCoSoSXKDInterviewed..[index].isSyncSuccess = isSynced);
      }
      update(danhSachBkCoSoSXKDInterviewed..[index].syncResult = syncResult);
    }
    danhSachBkCoSoSXKDInterviewed.refresh();
  }

  messageResultFinal() {
    //Tổng số phiếu cần đồng bộ;
    int total = danhSachBkCoSoSXKDInterviewed.length;
    int totalTB = danhSachBkCoSoSXKDInterviewed
        .where((x) => x.loaiPhieu == AppDefine.maDoiTuongDT_07TB)
        .length;
    int totalMau = danhSachBkCoSoSXKDInterviewed
        .where((x) => x.loaiPhieu == AppDefine.maDoiTuongDT_07Mau)
        .length;
//Tổng số lượng phiếu   đồng bộ thành công.
    int successTotal = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 2)
        .length;
    //Tổng số lượng phiếu   đồng bộ lỗi.
    int errorTotal = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 3)
        .length;
    //Tổng số phiếu đã đồng bộ:
    int syncedTotal = successTotal + errorTotal;

    //Tổng số lượng phiếu TB đồng bộ thành công.
    int successTotalTB = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 2 &&
            x.loaiPhieu == AppDefine.maDoiTuongDT_07TB)
        .length;
    //Tổng số lượng phiếu TB đồng bộ lỗi.
    int errorTotalTB = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 3 &&
            x.loaiPhieu == AppDefine.maDoiTuongDT_07TB)
        .length;
    //Tổng số lượng phiếu Mẫu đồng bộ thành công.
    int successTotalMau = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 2 &&
            x.loaiPhieu == AppDefine.maDoiTuongDT_07Mau)
        .length;
    //Tổng số lượng phiếu Mẫu đồng bộ lỗi.
    int errorTotalMau = danhSachBkCoSoSXKDInterviewed
        .where((x) =>
            x.syncResult != null &&
            x.syncResult!.resCode != null &&
            x.syncResult!.resCode == 3 &&
            x.loaiPhieu == AppDefine.maDoiTuongDT_07Mau)
        .length;

    responseMessage.value =
        'Tổng phiếu đã đồng bộ: $syncedTotal/${danhSachBkCoSoSXKDInterviewed.length}: Phiếu TB $successTotalTB/$totalTB; phiếu mẫu $successTotalMau/$totalMau';
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
