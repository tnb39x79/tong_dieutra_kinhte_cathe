import 'package:get/get.dart';
import 'enhanced_ai_download_controller_v2.dart';

class EnhancedAiDownloadBindingV2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnhancedAiDownloadControllerV2>(() => EnhancedAiDownloadControllerV2(Get.find()));
  }
}
