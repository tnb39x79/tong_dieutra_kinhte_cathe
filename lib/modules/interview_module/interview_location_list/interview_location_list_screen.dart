import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
  
import 'interview_location_list_controller.dart';

///Danh sách địa bàn hộ
class InterviewLocationListScreen extends GetView<InterviewLocationListController> {
  const InterviewLocationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
        loading: controller.loadingSubject,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBarHeader(
            title: 'locations'.tr,
            onPressedLeading: () => Get.back(),
            iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
             subTitle: controller.homeController.currentTenDoiTuongDT,    
           //  backAction: () => controller.onBackInterviewObjectList(),
          ),
          body: Obx(() => _buildBody()),
        ));
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: controller.diaBanCoSoSXKDs.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: AppValues.padding),
      itemBuilder: (context, index) {
        return WidgetLocationItem(
          index: '${index + 1}',
          title:
              '${controller.diaBanCoSoSXKDs[index].maDiaBan} - ${controller.diaBanCoSoSXKDs[index].maXa}',
          vilage: controller.diaBanCoSoSXKDs[index].tenDiaBan ?? '',
          onPressed: () => controller.onPressItem(index),
        );
      },
    );
  }
}
