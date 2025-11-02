import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/interview_module/widget/widget_group_menu_interview.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';

import 'interview_location_list_controller_v2.dart';

///Danh sách địa bàn hộ
class InterviewLocationListScreenV2
    extends GetView<InterviewLocationListControllerV2> {
  const InterviewLocationListScreenV2({Key? key}) : super(key: key);

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
          body: Obx(() => _buildBodyV2()),
        ));
  }

 

  Widget _buildBodyV2() {
    var diaBanDT = controller.diaBanCoSoSXKDs ;
    if (diaBanDT != null && diaBanDT.isNotEmpty) {
      return ListView.builder(
        itemCount: diaBanDT.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: AppValues.padding),
        itemBuilder: (context, index) {
          return WidgetLocationItem(
            index: '${index + 1}',
            title:
                'Địa bàn: ${diaBanDT[index].maDiaBan} - ${diaBanDT[index].tenDiaBan ?? ''}',
            vilage:
                '${AppUtils.getXaPhuong(diaBanDT[index].tenXa ?? '')}: ${diaBanDT[index].maXa} - ${diaBanDT[index].tenXa}',
            textStyleSub: styleMediumW400.copyWith(color: warningColor),
            onPressed: () => controller.onPressItem(index),
          );
        },
      );
    }
    return Text(
      'Không có địa bàn.',
      style: styleSmall,
    );
  }
}
