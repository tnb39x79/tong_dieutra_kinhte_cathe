import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
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
class InterviewListController extends BaseController {
  final HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const maDiaBanKey = 'maDiaBan';
  static const maDiaBanTGKey = 'maDiaBanTG';
  static const maXaKey = 'maXa';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";

  BKCoSoSXKDProvider bkCoSoSXKDProvider = BKCoSoSXKDProvider(); 

  final countOfUnInterviewed = 0.obs;
  final countOfInterviewed = 0.obs;

  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  String? currentMaDiaBan = Get.parameters[maDiaBanKey];
  String? currentMaDiaBanTG = Get.parameters[maDiaBanTGKey];
  String? currentMaXa = Get.parameters[maXaKey];

  @override
  void onInit() async {
    setLoading(true);
    await selectCountByType();
    setLoading(false);
    super.onInit();
  }

  getSubTitle() {
    String subTitle = currentTenDoiTuongDT;
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      subTitle = '$currentTenDoiTuongDT Địa bàn: $currentMaDiaBan';
    }
    return subTitle;
  }

  void backInterviewObjectList() {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      Get.toNamed(AppRoutes.interviewObjectList);
    } 
  }

  void toInterViewListDetail(int maTinhTrangDT) async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      await Get.toNamed(AppRoutes.interviewListDetail, parameters: {
        InterviewListDetailController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListDetailController.tenDoiTuongDTKey: currentTenDoiTuongDT,
        InterviewListDetailController.maTinhTrangDTKey: '$maTinhTrangDT',
        InterviewListDetailController.maDiaBanKey: currentMaDiaBan ?? '',
        InterviewListDetailController.maXaKey: currentMaXa ?? '',
      });
      selectCountByType();
    } else {
      snackBar('dialog_title_warning'.tr,
          'interview_undefine_investigate_object'.tr);
    }
  }

  Future selectCountByType() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      countOfUnInterviewed.value =
          await bkCoSoSXKDProvider.countOfUnInterviewed(
                  int.parse(currentMaDoiTuongDT), currentMaDiaBan!) ??
              0;
      countOfInterviewed.value = await bkCoSoSXKDProvider.countOfInterviewed(
              int.parse(currentMaDoiTuongDT), currentMaDiaBan!) ??
          0;
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      countOfUnInterviewed.value =
          await bkCoSoSXKDProvider.countOfUnInterviewed(
                  int.parse(currentMaDoiTuongDT), currentMaDiaBan!) ??
              0;
      countOfInterviewed.value = await bkCoSoSXKDProvider.countOfInterviewed(
              int.parse(currentMaDoiTuongDT), currentMaDiaBan!) ??
          0;
    }   else {
      countOfUnInterviewed.value = 0;
      countOfInterviewed.value = 0;
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
