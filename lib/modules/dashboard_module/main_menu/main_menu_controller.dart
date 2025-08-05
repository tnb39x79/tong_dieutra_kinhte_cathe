import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/auth/auth_repository.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';
import 'package:new_version_plus/new_version_plus.dart';

enum TypeTabBar {
  home,
  changePass,
}

class MainMenuController extends BaseController {
  MainMenuController({required this.authRepository});

  final AuthRepository authRepository;
  
  //RX
  final currentTabBar = TypeTabBar.home.obs;
  final userModel = UserModel().obs;
  Rx<TokenModel> loginData = TokenModel().obs;
  final isInitial = false.obs;
  final versionApp = ''.obs;

  @override
  void onInit() async {
    setLoading(true);
    versionApp.value = AppValues.versionApp;
    await getUser();
    if (AppPref.isFistInstall != 1) {
      await getCurrentVersion();
    }

    setLoading(false);

    //   loginData.listen(_onChangeLoginData);
    super.onInit();
  }

  Future<VersionStatus?> getCurrentVersion() async {
    try {
      final newVersion = NewVersionPlus(
        iOSId: AppValues.bundleIdIos,
        androidId: AppValues.bundleIdAndroid, // for test
      );

      final status = await newVersion.getVersionStatus();
      if (status != null) {
        AppPref.currentVersion = status.localVersion;
        log('current version: ${status.localVersion}');
        versionApp.value = status.localVersion;
      } else {
        AppPref.currentVersion = AppValues.versionApp;
        versionApp.value = AppValues.versionApp;
      }

      return status;
    } catch (e) {
      log('GET CURRENT VERSION: ${e.toString()}');
      AppPref.currentVersion = AppValues.versionApp;
    }
    return null;
  }

  onChangeLoginData(TokenModel value) {
    loginData.value = value;
    _onChangeLoginData(value);
  }

  _onChangeLoginData(TokenModel value) {
    final year = value.cuocDieuTra;
    if (year != null) {
      AppPref.yearKdt = int.parse(year.toString());

      log("Ky dieu tra $year", name: "MainMenuController");
    }
  }

  void onPressTabBar(TypeTabBar type) {
    if (type != currentTabBar.value) {
      currentTabBar.value = type;
    }
  }

  Future onPressLogOut() async {
    await Get.dialog(
      DialogLogOut(
        onPressedNegative: () => Get.back(),
        onPressedPositive: () async {
          await AppPref.clear();
          Get.offAllNamed(AppRoutes.splash);
        },
      ),
    );
  }

  Future getUser() async {
    bool isNetWork = NetworkService.connectionType != Network.none;
    String loginDataInfo = AppPref.loginData;
    String userDataInfo = AppPref.userData;
    var jsonInfo = jsonDecode(loginDataInfo);
    loginData.value = TokenModel.fromJson(jsonInfo);
    _onChangeLoginData(loginData.value);

    // set user from Cache for app
    if (userDataInfo != '') {
      log(userDataInfo);
      var jsonUserData = jsonDecode(userDataInfo);
      userModel.value = UserModel.fromJson(jsonUserData);
    } else {
      jsonInfo['TenNguoiDung'] = loginData.value.userName;
      userModel.value = UserModel.fromJson(jsonInfo);
      if (isNetWork) {
        final value = await authRepository.getUser();
        if (value.isSuccess) {
          userModel.value = value.body!;

          // save in cache for use when not connect internet
          String user = jsonEncode(value.body!);

          log('userData: $user');
          AppPref.userData = user;
        } else {
          snackBar('error'.tr, '${value.message}');
          Get.offAllNamed(AppRoutes.login);
        }

        setLoading(false);
      }
    }

    isInitial.value = true;
  }

  Future refreshUserData() async {
    setLoading(true);

    final value = await authRepository.getUser();
    if (value.isSuccess) {
      userModel.value = value.body!;

      // save in cache for use when not connect internet
      String _user = jsonEncode(value.body!);

      log('userData: $_user');
      AppPref.userData = _user;
    }

    setLoading(false);
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
