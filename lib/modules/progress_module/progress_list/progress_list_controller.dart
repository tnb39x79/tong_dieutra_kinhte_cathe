import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/database.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/progress_model.dart';

class ProgressListController extends BaseController {
  DmDoiTuongDieuTraProvider doiTuongDieuTraProvider =
      DmDoiTuongDieuTraProvider();
  final doiTuongDTs = <TableDoiTuongDieuTra>[].obs;
  final progressList = <ProgressModel>[].obs;

  BKCoSoSXKDProvider bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  BKCoSoTonGiaoProvider bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();

  // final countPhieuMauInterviewed = 0.obs;
  // final countPhieuMauUnInterviewed = 0.obs;
  // final countPhieuMauSyncSuccess = 0.obs;

  // final countPhieuTBInterviewed = 0.obs;
  // final countPhieuTBUnInterviewed = 0.obs;
  // final countPhieuTBSyncSuccess = 0.obs;

  // final countPhieuTonGiaoInterviewed = 0.obs;
  // final countPhieuTonGiaoUnInterviewed = 0.obs;
  // final countPhieuTonGiaoSyncSuccess = 0.obs;

  @override
  void onInit() async {
    setLoading(true);
    await listDoiTuongDT();
    // await getProgressCount();
    setLoading(false);
    super.onInit();
  }

  Future<void> listDoiTuongDT() async {
    progressList.clear();
  //  await Future.delayed(const Duration(seconds: 2));
    List<Map> map = await doiTuongDieuTraProvider.selectAll();
    // progressList.clear();
    for (var element in map) {
      // doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
      var dt = TableDoiTuongDieuTra.fromJson(element);
      var md = await getProgress(
          dt.maDoiTuongDT!, dt.tenDoiTuongDT!, dt.moTaDoiTuongDT!);
      progressList.add(md);
    }
    progressList.refresh();
  }

  Future<ProgressModel> getProgress(
      int maDoiTuongDT, String tenDoiTuongDT, String moTa) async {
    if (maDoiTuongDT == AppDefine.maDoiTuongDT_08) {
      ProgressModel progressModel = ProgressModel();
      progressModel.maDoiTuongDT = maDoiTuongDT;
      progressModel.tenDoiTuongDT = tenDoiTuongDT;
      progressModel.moTaDoiTuongDT = moTa;
      progressModel.countPhieuInterviewed =
          await bkCoSoTonGiaoProvider.countOfInterviewedAll() ?? 0;
      progressModel.countPhieuUnInterviewed =
          await bkCoSoTonGiaoProvider.countOfUnInterviewedAll() ?? 0;
      progressModel.countPhieuSyncSuccess =
          await bkCoSoTonGiaoProvider.countSyncSuccess() ?? 0;
      return progressModel;
    } else {
      ProgressModel progressModel = ProgressModel();
      progressModel.maDoiTuongDT = maDoiTuongDT;
      progressModel.tenDoiTuongDT = tenDoiTuongDT;
      progressModel.moTaDoiTuongDT = moTa;
      progressModel.countPhieuInterviewed =
          await bkCoSoSXKDProvider.countOfInterviewedAll(maDoiTuongDT) ?? 0;
      progressModel.countPhieuUnInterviewed =
          await bkCoSoSXKDProvider.countOfUnInterviewedAll(maDoiTuongDT) ?? 0;
      progressModel.countPhieuSyncSuccess =
          await bkCoSoSXKDProvider.countSyncSuccessAll(maDoiTuongDT) ?? 0;
      return progressModel;
    }
  }

  // Future getProgressCount() async {
  //   countPhieuMauUnInterviewed.value = await bkCoSoSXKDProvider
  //           .countOfUnInterviewedAll(AppDefine.maDoiTuongDT_07Mau) ??
  //       0;
  //   countPhieuMauInterviewed.value = await bkCoSoSXKDProvider
  //           .countOfInterviewedAll(AppDefine.maDoiTuongDT_07Mau) ??
  //       0;
  //   countPhieuMauSyncSuccess.value = await bkCoSoSXKDProvider
  //           .countSyncSuccessAll(AppDefine.maDoiTuongDT_07Mau) ??
  //       0;
  //   countPhieuTBUnInterviewed.value = await bkCoSoSXKDProvider
  //           .countOfUnInterviewedAll(AppDefine.maDoiTuongDT_07TB) ??
  //       0;
  //   countPhieuTBInterviewed.value = await bkCoSoSXKDProvider
  //           .countOfInterviewedAll(AppDefine.maDoiTuongDT_07TB) ??
  //       0;
  //   countPhieuTBSyncSuccess.value = await bkCoSoSXKDProvider
  //           .countSyncSuccessAll(AppDefine.maDoiTuongDT_07TB) ??
  //       0;
  //   countPhieuTonGiaoUnInterviewed.value =
  //       await bkCoSoTonGiaoProvider.countOfUnInterviewedAll() ?? 0;
  //   countPhieuTonGiaoInterviewed.value =
  //       await bkCoSoTonGiaoProvider.countOfInterviewedAll() ?? 0;
  //   countPhieuTonGiaoSyncSuccess.value =
  //       await bkCoSoTonGiaoProvider.countSyncSuccess() ?? 0;
  // }

  // countDoiTuong(int maDoiTuongDT, int maTrangThaiDT) {
  //   if (maDoiTuongDT == AppDefine.maDoiTuongDT_07Mau) {
  //     if (maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
  //       return countPhieuMauInterviewed.value;
  //     } else if (maTrangThaiDT == AppDefine.dangPhongVan) {
  //       return countPhieuMauUnInterviewed.value;
  //     } else if (maTrangThaiDT == 5) {
  //       return countPhieuMauSyncSuccess.value;
  //     }
  //   } else if (maDoiTuongDT == AppDefine.maDoiTuongDT_07TB) {
  //     if (maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
  //       return countPhieuTBInterviewed.value;
  //     } else if (maTrangThaiDT == AppDefine.dangPhongVan) {
  //       return countPhieuTBUnInterviewed.value;
  //     } else if (maTrangThaiDT == 5) {
  //       return countPhieuTBSyncSuccess.value;
  //     }
  //   } else if (maDoiTuongDT == AppDefine.maDoiTuongDT_08) {
  //     if (maTrangThaiDT == AppDefine.hoanThanhPhongVan) {
  //       return countPhieuTonGiaoInterviewed.value;
  //     } else if (maTrangThaiDT == AppDefine.dangPhongVan) {
  //       return countPhieuTonGiaoUnInterviewed.value;
  //     } else if (maTrangThaiDT == 5) {
  //       return countPhieuTonGiaoSyncSuccess.value;
  //     }
  //   }
  // }

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
