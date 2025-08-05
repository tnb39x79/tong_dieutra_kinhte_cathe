import 'package:get/get.dart';

import 'download_model_ai_controller.dart';

class DownloadModelAIBinding extends Bindings {
  @override
  void dependencies() { 
     Get.put(DownloadModelAIController());
  }
}
