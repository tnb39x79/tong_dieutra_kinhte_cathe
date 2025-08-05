import 'package:get/get.dart';

import 'active_status_controller.dart';

class ActiveStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActiveStatusController(
        errorLogRepository: Get.find(), xacnhanTukekhaiRepository: Get.find(),authRepository: Get.find()));
  }
}
