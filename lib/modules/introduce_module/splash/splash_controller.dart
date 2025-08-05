import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class SplashController extends BaseController {
  RxBool animate = false.obs;
  @override
  void onReady() async {
    // Timer(const Duration(seconds: 30), () {
    //   if (AppPref.accessToken != null &&
    //       AppPref.accessToken != '' &&
    //       AppPref.userData != '' &&
    //       AppPref.userData.isNotEmpty &&
    //       AppPref.loginData.isNotEmpty &&
    //       AppPref.loginData != '') {
    //     Get.offAllNamed(AppRoutes.mainMenu);
    //   } else {
    //     Get.offNamed(AppRoutes.login);
    //   }
    // });
    startAnimation();
    super.onReady();
  }

  @override
  void onInit() async {
    log('onInit');

    super.onInit();
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    Timer(const Duration(seconds: 2), () {
      if (AppPref.accessToken != null &&
          AppPref.accessToken != '' &&
          AppPref.userData != '' &&
          AppPref.userData.isNotEmpty &&
          AppPref.loginData.isNotEmpty &&
          AppPref.loginData != '') {
        Get.offAllNamed(AppRoutes.mainMenu);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }
}
