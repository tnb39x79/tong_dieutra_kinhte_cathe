import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import 'active_status_controller.dart';

class ActiveStatusScreen extends GetView<ActiveStatusController> {
  const ActiveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeader(
        title: 'status_active'.tr,
        iconLeading: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
        subTitle: controller.currentTenDoiTuongDT,
        onPressedLeading: () => Get.back(),
      ),
      body: LoadingFullScreen(
        loading: controller.loadingSubject,
        child: _buildBody(),
      ),
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
                indexFillColor: AppDefine.maTinhTrangHDTuKeKhai - 1,
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
