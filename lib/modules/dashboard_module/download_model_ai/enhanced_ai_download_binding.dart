import 'package:get/get.dart';
import 'enhanced_ai_download_controller.dart';

class EnhancedAiDownloadBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnhancedAiDownloadController>(() => EnhancedAiDownloadController(Get.find()));
  }
}
