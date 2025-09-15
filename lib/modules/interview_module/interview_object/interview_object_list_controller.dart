import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/dm_doituong_dieutra_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:gov_statistics_investigation_economic/routes/app_pages.dart';

///LUỒNG MÀN HÌNH:
///1. Danh sách đối tượng điều tra (interview_object)
///   Nếu là Cơ sở SXKD -> Danh sách phỏng vấn (interview_list)
///   Nếu là Hộ -> Danh sách địa bàn hộ (interview_location_list) -> Danh sách phỏng vấn (interview_list)
///2. Danh sách phỏng vấn (interview_list)
///   ->  Nếu là Cơ sở SXKD -> Danh sách Xã chưa phỏng vấn/Danh sách Xã đã phỏng vấn  (interview_list_detail)
///   ->  Nếu là Hộ -> Danh sách Hộ chưa phỏng vấn/Danh sách Hộ đã phỏng vấn  (interview_list_detail)
///
///Danh sách đối tượng điều tra
class InterviewObjectListController extends BaseController {
  final HomeController homeController = Get.find();

  DmDoiTuongDieuTraProvider doiTuongDieuTraProvider =
      DmDoiTuongDieuTraProvider();
  final doiTuongDTs = <TableDoiTuongDieuTra>[].obs;

  @override
  void onInit() async {
    setLoading(true);
    await listDoiTuongDT();
    setLoading(false);
    super.onInit();
  }

  Future listDoiTuongDT() async {
    List<Map> map = await doiTuongDieuTraProvider.selectAll();
    for (var element in map) {
      doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
    }
  }

  void onBackHome() async {
    Get.offAllNamed(AppRoutes.mainMenu);
  }

  Future onPressItem(int index) async {
    final maDT = doiTuongDTs[index].maDoiTuongDT;
    final tenDoiTuongDT = doiTuongDTs[index].tenDoiTuongDT;
    homeController.currentTenDoiTuongDT = tenDoiTuongDT!;
    if (maDT == AppDefine.maDoiTuongDT_07Mau) {
      toCosoSXKD(maDT!, tenDoiTuongDT);
    } else if (maDT == AppDefine.maDoiTuongDT_07TB) {
      await toCosoSXKD(maDT!, tenDoiTuongDT);
    }
    
  }

  Future toCosoSXKD(int maDT, String? tenDoiTuongDT) async {
    Get.toNamed(AppRoutes.interviewLocationList, parameters: {
      InterviewLocationListController.maDoiTuongDTKey: maDT.toString(),
      InterviewLocationListController.tenDoiTuongDTKey:
          tenDoiTuongDT.toString(),
    });
  }

  Future toTonGiao(int maDT, String? tenDoiTuongDT) async {
    Get.toNamed(AppRoutes.interviewList, parameters: {
      InterviewListController.maDoiTuongDTKey: maDT.toString(),
      InterviewListController.tenDoiTuongDTKey: tenDoiTuongDT.toString(),
    });
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
