import 'package:get/get.dart';
 
import 'interview_location_list_controller_v2.dart';

///Danh sách địa bàn hộ
class InterviewLocationListBindingV2 extends Bindings{
  @override
  void dependencies() {
    Get.put(InterviewLocationListControllerV2());
  }
}