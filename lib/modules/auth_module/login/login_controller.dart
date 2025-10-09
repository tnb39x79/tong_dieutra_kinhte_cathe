import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/auth/auth.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class LoginController extends BaseController {
  LoginController({required this.authRepository});

  final AuthRepository authRepository;

  // controller
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final mapInputControllers = <String, TextEditingController>{};

  final keyUserName = 'userName';
  final keyPass = 'pass';

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    mapInputControllers.forEach((key, value) {
      value.dispose();
    });
    super.onInit();
  }

  onPressedLogin() async {
    String userName = getEditingController(keyUserName).text.trim();
    String password = getEditingController(keyPass).text.trim();

    var resValidUserName = Valid.validateUserName(userName);
    if (resValidUserName != '' && resValidUserName != null) {
      return snackBar('Thông tin lỗi', resValidUserName!,
          style: ToastSnackType.error);
    }
    var resValidPass = Valid.validatePassword(password);
    if (resValidPass != '' && resValidPass != null) {
      return snackBar('Thông tin lỗi', resValidPass!,
          style: ToastSnackType.error);
    }
    setLoading(true);
    if (formKey.currentState!.validate()) {
      if (await _login()) {
        Get.offAllNamed(AppRoutes.mainMenu);
      }
    }
    setLoading(false);
  }

  TextEditingController getEditingController(String key) {
    if (mapInputControllers[key] == null) {
      mapInputControllers[key] = TextEditingController();
    }
    return mapInputControllers[key]!;
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    mapInputControllers.forEach((key, value) {
      value.dispose();
    });
    super.onClose();
  }

  Future<bool> _login() async {
    String userName = getEditingController(keyUserName).text.trim();
    String password = getEditingController(keyPass).text.trim();

    // if (!isConnected) {
    //   var loginBackUp = await backupProvider.login(userName, password);
    //   log('loginBackUp: $loginBackUp');
    // }
    bool result = await login(userName, password);
    return result;
  }

  Future<bool> login(String userName, String password) async {
    log('LOGIN: USER - $userName; PASSWORD: $password');
    try {
      String uniqueStringSameImei = AppPref.uniqueStringTheSameImei != ''
          ? AppPref.uniqueStringTheSameImei
          : await FlutterUdid.udid;
          
      final response = await authRepository
          .getToken(
            userName: userName,
            password: password,
            uniqueStringSameImei:uniqueStringSameImei
          )
          .timeout(const Duration(seconds: AppValues.timeOut));

      if (response.isSuccess) {
        AppPref.userName = userName;
        AppPref.password = password;
        AppPref.accessToken = response.body!.accessToken;
        AppPref.suggestionVcpaUrl = response.body!.suggestionVcpaUrl ?? '';
        //   DateTime now = DateTime.now();
        AppPref.lastLoginDate = DateTime.now()
            .toIso8601String(); //DateTime(now.year, now.month, 20).toIso8601String();//
        AppPref.uid = response.body!.userName;
        if (response.body!.userName != '') {
          AppPref.uid = response.body!.userName!.toUpperCase();
        }
        AppPref.loginData = jsonEncode(response.body!);

        ///added by tuannb 20/09/2024
        String? cuocDT = response.body!.cuocDieuTra;

        if (cuocDT != null) {
          AppPref.yearKdt = int.parse(cuocDT);

          log("Tổng điều tra kinh tế $cuocDT", name: "MainMenuController");
        }
        String? ngayKetThuc = response.body!.ngayKetThuc;
        String? xacNhanKetThuc = response.body!.xacNhanKetThuc;
        String? xoaDuLieu = response.body!.xoaDuLieu;
        AppPref.ngayKetThucDT = ngayKetThuc ?? '';
        AppPref.xacNhanKetThucDT = xacNhanKetThuc ?? '';
        AppPref.xoaDuLieuDT = xoaDuLieu ?? '';
        if (response.body!.soNgayHHDN != null) {
          AppPref.soNgayHetHanDangNhap = response.body!.soNgayHHDN!;
        } else {
          AppPref.soNgayHetHanDangNhap = '0';
        }
        if (response.body!.soNgayDT != null) {
          AppPref.soNgayChoPhepXoaDuLieu = response.body!.soNgayDT!;
        } else {
          AppPref.soNgayChoPhepXoaDuLieu = '0';
        }
        String imei = response.body!.iMei!;
        //AppPref.extraToken = response.body!.accessToken;

        final response0 = await authRepository
            .getExtraToken(
                userName: userName.trim(),
                password: password.trim(),
                url:
                    'http://${response.body!.domainAPI}:${response.body!.portAPI}/',
                iMei: imei)
            .timeout(const Duration(seconds: AppValues.timeOut));
        if (response0.isSuccess) {
          AppPref.extraToken = response0.body!.accessToken;
          final value = await authRepository.getUser();
          if (value.isSuccess) {
            //userModel.value = value.body!;

            // save in cache for use when not connect internet
            String user = jsonEncode(value.body!);

            log('userData: $user');
            AppPref.userData = user;
          }
          return true;
        }
      } else {
        if (response.statusCode == 500 || response.statusCode == 404) {
          _showError('can_not_connect_serve'.tr);
        } else if (response.errorDescription ==
            'Provided username and password is incorrect') {
          _showError('username_password_incorrect'.tr);
        } else {
          _showError(response.errorDescription ?? '');
        }
      }
      return false;
    } on TimeoutException catch (_) {
      _showError('can_not_connect_serve'.tr);
      return false;
    }
  }

  _showError(String msg) =>
      snackBar('error'.tr, msg, style: ToastSnackType.error);

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
