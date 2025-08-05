import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissiton {
  AppPermissiton._();

  static Future<bool> getStoragePermission() async {
    
    
    if (Platform.isIOS) {
       if (await Permission.storage.request().isGranted) {
          return true;
        } else {
          return false;
        }
    } else {
      AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
      if (build.version.sdkInt >= 30) {
        var re = await Permission.manageExternalStorage.request();
        if (re.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        if (await Permission.storage.request().isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}
