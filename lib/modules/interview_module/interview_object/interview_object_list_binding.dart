
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';

///Danh sách đối tượng điều tra
class InterviewObjectListBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(InterviewObjectListController());
  }
}