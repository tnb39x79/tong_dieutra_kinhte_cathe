import 'package:get/get.dart';

import 'interview_list_controller_v2.dart';

///Danh sách phỏng vấn:
///Gồm:
/// 1. currentMaDoiTuongDT=4
/// - Xã chưa phỏng vấn
/// - Xã đã phỏng vấn
/// hoặc
/// 2. currentMaDoiTuongDT=4
/// - Hộ chưa phỏng vấn
/// - Hộ đã phỏng vấn
class InterviewListBindingV2 extends Bindings{
  @override
  void dependencies() {
    Get.put(InterviewListControllerV2());
  }
}