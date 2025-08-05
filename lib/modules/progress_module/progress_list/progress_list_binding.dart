import 'package:get/get.dart';

import 'progress_list_controller.dart';

class ProgressListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProgressListController());
  }
}
