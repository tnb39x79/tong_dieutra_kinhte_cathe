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

 

  @override
  void onInit() async {
    setLoading(true);
    await listDoiTuongDT();
    
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
         String tenDT =  moTa;
      if ( maDoiTuongDT == AppDefine.maDoiTuongDT_07TB) {
        tenDT = 'Phiếu TB';
      }
      if ( maDoiTuongDT == AppDefine.maDoiTuongDT_07Mau) {
        tenDT = 'Phiếu mẫu';
      }
    ProgressModel progressModel = ProgressModel();
      progressModel.maDoiTuongDT = maDoiTuongDT;
      progressModel.tenDoiTuongDT = tenDoiTuongDT;
      progressModel.moTaDoiTuongDT = tenDT;
       progressModel.countTotal =
          await bkCoSoSXKDProvider.countAll(maDoiTuongDT) ?? 0;
      progressModel.countPhieuInterviewed =
          await bkCoSoSXKDProvider.countOfInterviewedAll(maDoiTuongDT) ?? 0;
      progressModel.countPhieuUnInterviewed =
          await bkCoSoSXKDProvider.countOfUnInterviewedAll(maDoiTuongDT) ?? 0;
      progressModel.countPhieuSyncSuccess =
          await bkCoSoSXKDProvider.countSyncSuccessAll(maDoiTuongDT) ?? 0;
           progressModel.countPhieuUnSync =
          await bkCoSoSXKDProvider.countPhieuUnSyncAll(maDoiTuongDT) ?? 0;
      return progressModel;
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
