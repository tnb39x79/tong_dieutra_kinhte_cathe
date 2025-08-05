import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart'; 
 
class InterviewListDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InterviewListDetailController());
  }
}
