import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

///Danh sách phỏng vấn:
///Gồm:
/// 1. currentMaDoiTuongDT=1, 2
/// - Cơ sở chưa phỏng vấn
/// - Cơ sở đã phỏng vấn
/// hoặc
/// 2. currentMaDoiTuongDT=53
/// - Xã chưa phỏng vấn
/// - Xã đã phỏng vấn
class InterviewListControllerV2 extends BaseController {
  final HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const maDiaBanKey = 'maDiaBan';
  static const tenDiaBanKey = 'tenDiaBan';
  static const maXaKey = 'maXa';
  static const tenXaKey = 'tenXa';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";

  BKCoSoSXKDProvider bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  DmDoiTuongDieuTraProvider doiTuongDieuTraProvider =
      DmDoiTuongDieuTraProvider();
  final doiTuongDTs = <TableDoiTuongDieuTra>[].obs;

  final countOfUnInterviewed = 0.obs;
  final countOfInterviewed = 0.obs;
    final countOfUnInterviewedMau = 0.obs;
  final countOfInterviewedMau = 0.obs;
  final allowAddNewCoSo = false.obs;

  String? currentMaDiaBan = Get.parameters[maDiaBanKey];
  String? currentTenDiaBan = Get.parameters[tenDiaBanKey];
  String? currentMaXa = Get.parameters[maXaKey];
  String? currentTenXa = Get.parameters[tenXaKey];

  @override
  void onInit() async {
    setLoading(true);
    await doiTuongDTList();
    await selectCountByType();
    setLoading(false);
    super.onInit();
  }

  getSubTitle() {
    String tt = AppUtils.getXaPhuong(currentTenXa ?? '');
    String subTitle =
        'Địa bàn.$currentMaDiaBan - $currentTenDiaBan $tt. $currentMaXa - $currentTenXa';

    return subTitle;
  }

  void backInterviewObjectList() { 
      Get.toNamed(AppRoutes.interviewLocationListV2); 
  }

Future doiTuongDTList() async {
    List<Map> map = await doiTuongDieuTraProvider.selectAll();
    for (var element in map) {
      doiTuongDTs.add(TableDoiTuongDieuTra.fromJson(element));
    }
  }

  void toInterViewListDetail(TableDoiTuongDieuTra dtDT,int maTinhTrangDT) async {
     
      await Get.toNamed(AppRoutes.interviewListDetail, parameters: {
        InterviewListDetailController.maDoiTuongDTKey: dtDT.maDoiTuongDT!.toString(),
        InterviewListDetailController.tenDoiTuongDTKey: dtDT.tenDoiTuongDT!,
        InterviewListDetailController.maTinhTrangDTKey: '$maTinhTrangDT',
        InterviewListDetailController.maDiaBanKey: currentMaDiaBan ?? '',
        InterviewListDetailController.tenDiaBanKey: currentTenDiaBan ?? '',
        InterviewListDetailController.maXaKey: currentMaXa ?? '',
        InterviewListDetailController.tenXaKey: currentTenXa ?? '',
      });
      selectCountByType(); 
  }

  Future selectCountByType() async {
    
      countOfUnInterviewedMau
          .value = await bkCoSoSXKDProvider.countOfUnInterviewed(
               AppDefine.maDoiTuongDT_07Mau, currentMaDiaBan!, currentMaXa!) ??
          0;
      countOfInterviewedMau.value = await bkCoSoSXKDProvider.countOfInterviewed(
               AppDefine.maDoiTuongDT_07Mau, currentMaDiaBan!, currentMaXa!) ??
          0;
    
      countOfUnInterviewed
          .value = await bkCoSoSXKDProvider.countOfUnInterviewed(
               AppDefine.maDoiTuongDT_07TB, currentMaDiaBan!, currentMaXa!) ??
          0;
      countOfInterviewed.value = await bkCoSoSXKDProvider.countOfInterviewed(
               AppDefine.maDoiTuongDT_07TB, currentMaDiaBan!, currentMaXa!) ??
          0;
    
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
