import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_controller_v2.dart';

class SyncBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.put(SyncControllerV2(
        syncRepository: Get.find(), sendErrorRepository: Get.find()));
  }
}
