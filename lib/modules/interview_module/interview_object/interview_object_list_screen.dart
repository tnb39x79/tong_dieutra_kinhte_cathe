import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';

///Danh sách đối tượng điều tra
class InterviewObjectListScreen extends GetView<InterviewObjectListController> {
  const InterviewObjectListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'interview'.tr,
          onPressedLeading: () =>Get.back(),
          iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
           //backAction: () => controller.onBackHome(),
        ),
        body: Obx(() => _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: controller.doiTuongDTs.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: AppValues.padding),
      itemBuilder: (context, index) {
        return WidgetMenuInterview(
          title: '${controller.doiTuongDTs[index].moTaDoiTuongDT}',
          onPressed: () => controller.onPressItem(index),
         // subTitle:  '${controller.doiTuongDTs[index].tenDoiTuongDT}',
        );
      },
    );
  }
}
