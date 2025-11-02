import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

///Danh sách địa bàn hộ
class InterviewLocationListControllerV2 extends BaseController {
  HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";

  // String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  // String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  // db provider
  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();
  final bKCoSoSXKDProvider = BKCoSoSXKDProvider();

  //RX
  final diaBanCoSoSXKDs = <TableDmDiaBanCosoSxkd>[].obs;
  final tblCoSoSXKDs = <TableBkCoSoSXKD>[].obs;
  DmDoiTuongDieuTraProvider doiTuongDieuTraProvider =
      DmDoiTuongDieuTraProvider();
  final doiTuongDTs = <TableDoiTuongDieuTra>[].obs;
  dynamic data;

  @override
  void onInit() async {
    setLoading(true);
    await doiTuongDTList();
    await getAllCoSoSXKD();
    setLoading(false);

    super.onInit();
  }
  Future doiTuongDTList() async {
    List<Map> map = await doiTuongDieuTraProvider.selectAll();
    for (var element in map) {
      doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
    }
  }
  void onBackInterviewObjectList() {
    Get.toNamed(AppRoutes.interviewObjectList);
  }

  void onPressItem(int index) {
    Get.toNamed(AppRoutes.interviewListV2, parameters: { 
      InterviewListControllerV2.maDiaBanKey: diaBanCoSoSXKDs[index].maDiaBan!,
      InterviewListControllerV2.tenDiaBanKey: diaBanCoSoSXKDs[index].tenDiaBan!,
      InterviewListControllerV2.maXaKey: diaBanCoSoSXKDs[index].maXa!,
      InterviewListControllerV2.tenXaKey: diaBanCoSoSXKDs[index].tenXa!,
    });
  }
 Future getAllCoSoSXKD() async {
    List<Map> map = await diaBanCoSoSXKDProvider.selectAllByMaPhieu();
    diaBanCoSoSXKDs.clear();
    for (var element in map) {
      diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
    }
  }
  // Future getCoSoSXKD(int maDTDT) async {
  //   List<Map> map = await diaBanCoSoSXKDProvider
  //       .selectByMaPhieu(int.parse(currentMaDoiTuongDT!));
  //   diaBanCoSoSXKDs.clear();
  //   for (var element in map) {
  //     diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
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
