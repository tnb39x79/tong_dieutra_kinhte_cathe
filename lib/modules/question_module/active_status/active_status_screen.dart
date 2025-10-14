import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/appbars/appbar_customize.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import 'active_status_controller.dart';

class ActiveStatusScreen extends GetView<ActiveStatusController> {
  const ActiveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'status_active'.tr,
        iconLeading: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        subTitle: controller.subTitleBar.value,
        onPressedLeading: () => Get.back(),
        wTitle: Obx(() => appBarTitle()),
      ),
      body: LoadingFullScreen(
        loading: controller.loadingSubject,
        child: _buildBody(),
      ),
    );
  }

  Widget appBarTitle() {
     var t =
        '${controller.currentTenPhieu.value != null && controller.currentTenPhieu.value != '' ? controller.currentTenPhieu.value : controller.currentTenDoiTuongDT}';
    return (controller.subTitleBar == null || controller.subTitleBar == "")
        ? Text(t, style: styleMediumBold)
        : ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(
              t,
              style: styleMediumBoldAppBarHeader,
              textAlign: TextAlign.left,
            ),
            subtitle: Text(controller.subTitleBar.value,
                style: const TextStyle(color: Colors.white)),
            titleAlignment: ListTileTitleAlignment.center,
          );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppValues.padding),
      child: Column(
        children: [Expanded(child: Obx(() => _question())), _button()],
      ),
    );
  }

  Widget _question() {
    return Column(
      children: controller.tinhTrangHDs
          .map(
            (e) => Obx(
              () => CheckBoxCircle(
                text: e.tenTinhTrang!,
                index: controller.tinhTrangHDs.indexOf(e),
                currentIndex: controller.currentIndex.value,
                //  indexFillColor: controller.tinhTrangHDs.lastIndexOf(controller.tinhTrangHDs.last),
                
                onPressed: controller.onPressedCheckBox,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _button() {
    return WidgetButtonNext(
      onPressed: controller.onPressNext,
      width: Get.width,
    );
  }
}
