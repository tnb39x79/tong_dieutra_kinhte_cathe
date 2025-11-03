import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/i_button.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/widget_row_item.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/interview_module/interview_list/interview_list_controller_v2.dart';
import 'package:gov_statistics_investigation_economic/modules/interview_module/widget/widget_group_menu_interview.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';

///Danh sách phỏng vấn:
///Gồm:
/// 1. currentMaDoiTuongDT=4
/// - Xã chưa phỏng vấn
/// - Xã đã phỏng vấn
/// hoặc
/// 2. currentMaDoiTuongDT=4
/// - Hộ chưa phỏng vấn
/// - Hộ đã phỏng vấn
class InterviewListScreenV2 extends GetView<InterviewListControllerV2> {
  const InterviewListScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'interview_list'.tr,
          onPressedLeading: () => Get.back(),
          iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
          subTitle: controller.getSubTitle(),
          //   backAction: () => controller.backInterviewObjectList(),
        ),
        body: _buildBodyV2(),
      ),
    );
  }

  Widget _buildBodyV2() {
    return Obx(() {
      return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            itemCount: controller.doiTuongDTs.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: AppValues.padding),
            itemBuilder: (context, index) {
              var dtDT = controller.doiTuongDTs[index];
              return _buildSubBody(dtDT);
            },
          ));
    });
  }

  Widget _buildSubBody(TableDoiTuongDieuTra dtDT) {
    return Obx(() {
      String tenDT = dtDT.moTaDoiTuongDT ?? '';
      if (dtDT.maDoiTuongDT == AppDefine.maDoiTuongDT_07TB) {
        tenDT = 'Phiếu TB';
      }
      if (dtDT.maDoiTuongDT == AppDefine.maDoiTuongDT_07Mau) {
        tenDT = 'Phiếu mẫu';
      }

      return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: greyLight,
                offset: const Offset(0, 2),
                spreadRadius: 1,
                blurRadius: AppValues.borderLv1,
              ),
            ],
          //  border: Border.all(color: primary1LighterColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(AppValues.borderLv2)),
          ),
          child: Column(
            children: [
              WidgetGroupMenuInterview(
                title: tenDT,
                onPressed: () => {},
                showIconAction: false,
                wPadding: EdgeInsets.fromLTRB(
                    AppValues.padding, AppValues.padding, AppValues.padding, 0),
                bgColor: Colors.transparent,
              ),
              const SizedBox(height: AppValues.padding),
              WidgetRowItem(
                title: 'un_interviewed'.trParams({'param': 'coso'.tr}),
                count: (dtDT.maDoiTuongDT == AppDefine.maDoiTuongDT_07TB)
                    ? controller.countOfUnInterviewed.value
                    : controller.countOfUnInterviewedMau.value,
                onPressed: () => controller.toInterViewListDetail(
                    dtDT, AppDefine.chuaPhongVan),
              ),
              WidgetRowItem(
                title: 'interviewed'.trParams({
                  'param': 'coso'.tr,
                }),
                count: (dtDT.maDoiTuongDT == AppDefine.maDoiTuongDT_07TB)
                    ? controller.countOfInterviewed.value
                    : controller.countOfInterviewedMau.value,
                onPressed: () => controller.toInterViewListDetail(
                    dtDT, AppDefine.dangPhongVan),
              ),
              if (controller.allowAddNewCoSo.value && dtDT.maDoiTuongDT == AppDefine.maDoiTuongDT_07TB)
                Padding(
                    padding: EdgeInsets.all(AppValues.borderLv5),
                    child: WidgetButton(
                      iconCenter: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => {},
                      title: 'Thêm mới cơ sở',
                      background: primaryColor,
                    ))
            ],
          ));
    });
  }
}
