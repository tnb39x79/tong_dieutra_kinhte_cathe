import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/progress_module.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/w_card.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class ProgressListScreen extends GetView<ProgressListController> {
  const ProgressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'progress'.tr,
          onPressedLeading: () => Get.offNamed(AppRoutes.mainMenu),
          iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
          actions: const SizedBox(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
                const Duration(seconds: 1), () => controller.listDoiTuongDT);
          },
          color: primaryColor,
          child: ListView.builder(
            itemCount: controller.progressList.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: AppValues.padding),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  WCard(
                    titleHeader: controller.progressList[index].moTaDoiTuongDT!,
                    doiTuongDT:
                        controller.progressList[index].maDoiTuongDT.toString(),
                    countInterviewed:
                        controller.progressList[index].countPhieuInterviewed ??
                            0,
                    countUnInterviewed: controller
                            .progressList[index].countPhieuUnInterviewed ??
                        0,
                    countSyncSuccess:
                        controller.progressList[index].countPhieuSyncSuccess ??
                            0,
                    countUnSync:
                        controller.progressList[index].countPhieuUnSync ?? 0,
                  )
                ],
              );
            },
          ));
    });
  }
}
