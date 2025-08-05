import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import 'package:gov_statistics_investigation_economic/modules/modules.dart';

class MainMenuScreen extends GetView<MainMenuController> {
  const MainMenuScreen({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return LoadingFullScreen(
  //     child: GestureDetector(
  //       onTap: () => controller.unFocus(context),
  //       child: Scaffold(
  //         appBar: _builAppBar(),
  //         body: _buildBody(),
  //       ),
  //     ),
  //     loading: controller.loadingSubject,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: GestureDetector(
        onTap: () => controller.unFocus(context),
        child: Scaffold(
          appBar: _builAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return controller.currentTabBar.value == TypeTabBar.home
          ? const HomeScreen()
          : const ChangePassScreen();
    });
  }

  AppBar _builAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 93,
      bottom: _preferrdSize(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppValues.borderLv5),
        ),
      ),
      centerTitle: false,
      title: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${controller.userModel.value.maDangNhap ?? ''} \n${controller.userModel.value.tenNguoiDung ?? ''}',
                style: styleMediumBold),
            Text(
                'sesstion_servey'.trParams({
                  'param': AppPref.yearKdt > 0 ? AppPref.yearKdt.toString() : ''
                }),
                style: styleSmall),
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: true,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.padding, vertical: 4),
              child: Column(
                children: [
                  Text('current_version'.tr),
                  const Text(
                    AppValues.versionApp,
                    style: styleMedium,
                  )
                ],
              )),
        ),
      ],
    );
  }

  PreferredSize _preferrdSize() {
    return PreferredSize(
      preferredSize: Size(double.infinity, Get.height * 0.18),
      child: SizedBox(
          width: Get.width,
          height: Get.height * 0.18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => WidgetItemHeader(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    icon: AppIcons.icHome,
                    isSelected:
                        controller.currentTabBar.value == TypeTabBar.home
                            ? true
                            : false,
                    onPressed: () => controller.onPressTabBar(TypeTabBar.home),
                    name: 'home'.tr,
                  )),
              Obx(() => WidgetItemHeader(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    icon: AppIcons.icLockBool,
                    isSelected:
                        controller.currentTabBar.value == TypeTabBar.changePass
                            ? true
                            : false,
                    onPressed: () =>
                        controller.onPressTabBar(TypeTabBar.changePass),
                    name: 'change_pass'.tr,
                  )),
              WidgetItemHeader(
                height: Get.height * 0.08,
                width: Get.height * 0.08,
                icon: AppIcons.icLogOut,
                isSelected: false,
                onPressed: controller.onPressLogOut,
                name: 'logout'.tr,
              ),
            ],
          )),
    );
  }
}
