import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

///Danh sách địa bàn hộ
class InterviewLocationListController extends BaseController {
  HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";

  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  // db provider
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final bKCoSoSXKDProvider = BKCoSoSXKDProvider();

  //RX
  final diaBanCoSoSXKDs = <TableDmDiaBanCosoSxkd>[].obs;
  final tblCoSoSXKDs = <TableBkCoSoSXKD>[].obs;

  dynamic data;

  @override
  void onInit() async {
    setLoading(true);
    await getCoSoSXKD();
    setLoading(false);

    super.onInit();
  }

  void onBackInterviewObjectList() {
    Get.toNamed(AppRoutes.interviewObjectList);
  }

  void onPressItem(int index) {
    Get.toNamed(AppRoutes.interviewList, parameters: {
      InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
      InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      InterviewListController.maDiaBanKey: diaBanCoSoSXKDs[index].maDiaBan!,
      InterviewListController.tenDiaBanKey: diaBanCoSoSXKDs[index].tenDiaBan!,
      InterviewListController.maXaKey: diaBanCoSoSXKDs[index].maXa!,
      InterviewListController.tenXaKey: diaBanCoSoSXKDs[index].tenXa!,
    });
  }

  Future getCoSoSXKD() async {
    List<Map> map = await diaBanCoSoSXKDProvider
        .selectByMaPhieu(int.parse(currentMaDoiTuongDT!));
    diaBanCoSoSXKDs.clear();
    for (var element in map) {
      diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
    }
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
