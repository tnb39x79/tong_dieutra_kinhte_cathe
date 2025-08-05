import 'package:get/get.dart';
 
import 'interview_location_list_controller.dart';

///Danh sách địa bàn hộ
class InterviewLocationListBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(InterviewLocationListController());
  }
}