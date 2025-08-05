import 'dart:convert';
import 'dart:developer';
 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:gov_statistics_investigation_economic/common/utils/utils.dart'; 
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/model/auth/user_model.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/auth/auth.dart'; 

 

class ChangePassController extends BaseController {
  ChangePassController({required this.authRepository});
  final AuthRepository authRepository;
  final mainMenuController = Get.find<MainMenuController>();
  final homeController = Get.find<HomeController>();

  //
  final formKey = GlobalKey<FormState>();

  final mapInputControllers = <String, TextEditingController>{};

  // controller
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  String currentPassword = '';
  @override
  void onClose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    mapInputControllers.forEach((key, value) {
      value.dispose();
    });
    super.onClose();
  }

  resetController() {
    currentPassController.text = '';
    newPassController.text = "";
    confirmPassController.text = "";
    mapInputControllers.forEach((key, value) {
      value.text = "";
    });
  }

  TextEditingController getEditingController(String key) {
    if (mapInputControllers[key] == null) {
      mapInputControllers[key] = TextEditingController();
    }
    return mapInputControllers[key]!;
  }

  onPressChangePass() async {
    await mainMenuController.getUser();
    currentPassword = mainMenuController.userModel.value.matKhau!;
    if (formKey.currentState!.validate()) {
      await changePass(mainMenuController.userModel.value);
    }
  }

  String? validateConfirmPassword(String? p1) {
    if (p1 != getEditingController('new_pass').text) {
      return 'validate_confirm_pass'.tr;
    }
    return null;
  }

  String? validateCurrentPassword(String? p1) {
    var bytes = utf8.encode(p1 ?? ""); // data being hashed
    var md5Cover = md5.convert(bytes);
    String currentPass = mainMenuController.userModel.value.matKhau ?? "";

    if ('$md5Cover' != currentPass) {
      return 'Mật khẩu không khớp với mật khẩu hiện tại';
    } else if (p1 == null) {
      return 'validate_empty'.trParams({'param': 'hint_pass'.tr});
    } else {
      return null;
    }
  }

  String? validateNewPass(String? value) {
    if (value == null || value == "") {
      return "Vui lòng nhập mật khẩu mới";
    }

    if (value == getEditingController('current_pass').text) {
      return 'Mật khẩu đã cũ, vui lòng chọn nhập mật khẩu khác';
    }

    return null;
  }

  // Future changePass(UserModel userModel) async {
  //   FocusManager.instance.primaryFocus?.unfocus();

  //   String? confirmPassValidation =
  //       validateConfirmPassword(getEditingController('confirm_new_pass').text);
  //   String? currentPassValidation =
  //       validateCurrentPassword(getEditingController('current_pass').text);
  //   String? newPassValidation =
  //       validateNewPass(getEditingController('new_pass').text);
  //   if (currentPassValidation != null) {
  //     return snackBar('error'.tr, currentPassValidation,
  //         style: ToastSnackType.error);
  //   }

  //   if (newPassValidation != null) {
  //     return snackBar('error'.tr, newPassValidation,
  //         style: ToastSnackType.error);
  //   }
  //   if (confirmPassValidation != null) {
  //     return snackBar('error'.tr, confirmPassValidation,
  //         style: ToastSnackType.error);
  //   }

  //   String _newPass = getEditingController('confirm_new_pass').text;

  //   userModel.matKhau = _newPass;
  //   log('userModel: ${userModel.toJson()}');
  //   bool result = await authRepository.updateUser(
  //       userModel.maDangNhap!, userModel.toJson());
  //   if (result) {
  //     AppPref.password = _newPass;
  //     await homeController.refreshLoginData();
  //     await mainMenuController.refreshUserData();
  //     snackBar('success'.tr, 'Đổi mật khẩu thành công!');
  //   } else {
  //     snackBar(
  //       'error'.tr,
  //       'Đổi mật khẩu không thành công!',
  //       style: ToastSnackType.error,
  //     );
  //   }
  // }
  
  Future changePass(UserModel userModel) async {
    //  String signaturePwd2 =
    //     '${userModel.maDangNhap}:12345:1:${userModel.maTinh}';
    //     var bytes2 = utf8.encode(signaturePwd2);
    // var md5Cover2 = md5.convert(bytes2);
    FocusManager.instance.primaryFocus?.unfocus();
    String currentPwd = getEditingController('current_pass').text;
    String? confirmPassValidation =
        validateConfirmPassword(getEditingController('confirm_new_pass').text);
    String? currentPassValidation = validateCurrentPassword(currentPwd);
    String? newPassValidation =
        validateNewPass(getEditingController('new_pass').text);
    if (currentPassValidation != null) {
      return snackBar('error'.tr, currentPassValidation,
          style: ToastSnackType.error);
    }

    if (newPassValidation != null) {
      return snackBar('error'.tr, newPassValidation,
          style: ToastSnackType.error);
    }
    if (confirmPassValidation != null) {
      return snackBar('error'.tr, confirmPassValidation,
          style: ToastSnackType.error);
    }

    String newPass = getEditingController('confirm_new_pass').text;

    userModel.matKhau = newPass;
    log('userModel: ${userModel.toJson()}');
    String signaturePwd =
        '${userModel.maDangNhap}:$currentPwd:$newPass:${userModel.maTinh}';
    var bytes = utf8.encode(signaturePwd);
    var md5Cover = md5.convert(bytes);
    UserPwdModel userPwdModel = UserPwdModel(
        maDangNhap: userModel.maDangNhap,
        matKhauHienTai: currentPwd,
        matKhau: newPass,
        maTinh: userModel.maTinh,
        signature: md5Cover.toString());
    bool result = await authRepository.changePassword(
        userModel.maDangNhap!, userPwdModel.toJson());
    if (result) {
      AppPref.password = newPass;
      await homeController.refreshLoginData();
      await mainMenuController.refreshUserData();
      snackBar('success'.tr, 'Đổi mật khẩu thành công!');
      resetController();
    } else {
      snackBar(
        'error'.tr,
        'Đổi mật khẩu không thành công!',
        style: ToastSnackType.error,
      );
    }
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
