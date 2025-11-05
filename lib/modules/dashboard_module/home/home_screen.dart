import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/dashboard_module.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Obx(() => Stack(children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              crossAxisSpacing: AppValues.padding,
              mainAxisSpacing: AppValues.padding,
              crossAxisCount: 2,
              children: _items(),
            ),
          ),
          if (controller.isHomeLoading.value)
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: backgroundColor.withValues(alpha: 0.5),
              ),
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 244, 180, 53), 
                ),
              ),
            ),
        ]));
  }

  List<Widget> _items() {
    // if (controller.isDefaultUserType()) {

    return <Widget>[
      WidgetItemMainMenu(
        name: 'interview'.tr,
        onPressed: controller.onInterViewScreen,
        icon: AppIcons.icPaper,
      ),
      TapDebouncer(
          cooldown: const Duration(milliseconds: 1000),
          onTap: () async => await controller.taiDuLieuPV(),
          builder: (BuildContext context, TapDebouncerFunc? onTap) {
            return WidgetItemMainMenu(
              name: 'get_data'.tr,
              onPressed: () {
                if (onTap != null) onTap();
              },
              icon: AppIcons.icGetData,
            );
          }),
      WidgetItemMainMenu(
        name: 'post_data'.tr,
        onPressed: controller.onSyncDataScreen,
        icon: AppIcons.icSync,
      ),
      WidgetItemMainMenu(
        name: 'progress'.tr,
        onPressed: controller.onProgressViewScreen,
        icon: AppIcons.icRouteWhite,
      ),
      WidgetItemMainMenu(
        name: 'update_app_title'.tr,
        onPressed: controller.checkUpdateApp,
        icon: AppIcons.icDownload,
      ),
      WidgetItemMainMenu(
        name: 'update_model_ai_title'.tr,
        onPressed: controller.onDownloadModelAI,
        icon: AppIcons.icDownloadAI,
      ),
    ];
    // } else {
    //   return _itemsTuKeKhai();
    // }
  }

  // List<Widget> _itemsTuKeKhai() {
  //   return <Widget>[
  //     WidgetItemMainMenu(
  //       name: 'Khai phiếu',
  //       onPressed: controller.onInterViewScreen,
  //       icon: AppIcons.icPaper,
  //     ),
  //     TapDebouncer(
  //         cooldown: const Duration(milliseconds: 1000),
  //         onTap: () async => await controller.onGetDuLieuPhieu(),
  //         builder: (BuildContext context, TapDebouncerFunc? onTap) {
  //           return WidgetItemMainMenu(
  //             name: 'get_data'.tr,
  //             onPressed: () {
  //               if (onTap != null) onTap();
  //             },
  //             icon: AppIcons.icGetData,
  //           );
  //         }),
  //     WidgetItemMainMenu(
  //       name: 'Gửi dữ liệu',
  //       onPressed: controller.onSyncDataScreen,
  //       icon: AppIcons.icSync,
  //     ),
  //     WidgetItemMainMenu(
  //       name: 'update_app_title'.tr,
  //       onPressed: controller.checkUpdateApp,
  //       icon: AppIcons.icDownload,
  //     ),
  //   ];
  // }
}
