import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';

import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
