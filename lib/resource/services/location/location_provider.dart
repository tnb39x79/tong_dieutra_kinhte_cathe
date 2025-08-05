import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

class LocationProVider {
  static Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      log('checkPermission Location: Location permissions are denied');

      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      log('checkPermission Location: Location permissions are denied forever');

      return false;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    return false;
  }

  static Future<bool> requestLocationServices() async {
    // if true => request location
    // if false => app setting for enable location services

    bool isEnableLocation = await Geolocator.isLocationServiceEnabled();
    log('_isEnableLocation: $isEnableLocation');

    if (!isEnableLocation) {
      Get.dialog(DialogWidget(
          onPressedPositive: () {
            Get.back();
            Geolocator.openLocationSettings();
          },
          onPressedNegative: () {
            Get.back();
          },
          title: 'Ứng dụng chưa bật vị trí',
          content: 'Vui lòng bật vị trí để cập nhật vị trí điều tra'));
    }

    return isEnableLocation;
  }

  static Future<bool> requestPermission() async {
    // if true => request location
    // if false => app setting for enable location services

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      log('checkPermission Location: Location permissions are denied');

      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      log('checkPermission Location: Location permissions are denied forever');

      return false;
    }

    return false;
  }

  static Future<Position> getLocation() async {
    // bool   await checkPermission();
    //await requestLocationServices();
    // await requestPermission();
    return await Geolocator.getCurrentPosition();
  }
 
}