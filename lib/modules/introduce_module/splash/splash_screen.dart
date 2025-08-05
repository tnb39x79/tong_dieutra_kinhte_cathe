import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import 'splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.loose,
      children: [
        Container(
          width: Get.width,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppImages.imgBackground,
              ),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(
              top: Get.height * 0.12, bottom: Get.height * 0.15),
        ),
        Obx(
          () => AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            top: controller.animate.value ? 120 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: controller.animate.value ? 1 : 0,
              child: Image.asset(
                AppImages.imgLogoCircle,
                width: Get.width * 0.35,
                height: Get.width * 0.35,
              ),
            ),
          ),
        ),
        Obx(
          () => AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            bottom: controller.animate.value ? 160 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: controller.animate.value ? 1 : 0,
              child: Text(
                'slogan'.tr,
                style: styleLargeBold.copyWith(color: Colors.white,fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
         Obx(
          () => AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            bottom: controller.animate.value ? 135 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: controller.animate.value ? 1 : 0,
              child: Text(
                'slogan2'.tr,
                style: styleLargeBold.copyWith(color: Colors.white,fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        // Obx(
        //   () => AnimatedPositioned(
        //     duration: const Duration(milliseconds: 3500),
        //     bottom: controller.animate.value ? 110 : 110,
        //     child: AnimatedOpacity(
        //       duration: const Duration(milliseconds: 2000),
        //       opacity: controller.animate.value ? 1 : 0,
        //       child: Text(
        //         "2025",
        //         style: styleLargeBold.copyWith(color: Colors.white,fontSize: 16),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }


  // Widget _buildBody() {
  //   return Container(
  //     width: Get.width,
  //     decoration: const BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage(
  //           AppImages.imgBackground,
  //         ),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     padding:
  //         EdgeInsets.only(top: Get.height * 0.12, bottom: Get.height * 0.15),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Image.asset(
  //           AppImages.imgLogoCircle,
  //           width: Get.width * 0.35,
  //           height: Get.width * 0.35,
  //         ),
  //         const Spacer(),
  //         Text(
  //           'slogan'.tr,
  //           style: styleLargeBold.copyWith(color: Colors.white),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
