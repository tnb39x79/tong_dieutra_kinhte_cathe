import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/percent_indicator/percent_indicator.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/download_model_ai_controller.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api_constants.dart';
import 'package:gov_statistics_investigation_economic/resource/services/network_service/network_service.dart';
import 'package:gov_statistics_investigation_economic/routes/routes.dart';

class DownloadModelAIScreen extends GetView<DownloadModelAIController> {
  const DownloadModelAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'update_model_ai_title'.tr,
          onPressedLeading: () => Get.offNamed(AppRoutes.mainMenu),
          iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
          actions: const SizedBox(),
          backAction: controller.onBackHome,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(AppValues.padding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - kToolbarHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildContent(),
                  const SizedBox(height: 36),
                  _handleButton()
                ],
              ),
            ));
      },
    );
  }

  Widget buildContent() {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Tải dữ liệu AI',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 32,
          ),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            // animation: true,
            percent: controller.downloadProgressNotifier.value / 100,
            center: Text(
              "${controller.downloadProgressNotifier.value}%",
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color.fromARGB(255, 34, 187, 51),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
              '${controller.receivedBytes.value ~/ 1024}/${controller.totalBytes.value ~/ 1024} KB'),
          _handleResult(),
          // _handleCompleted(),
          //_handleButtonDownload(),
        ],
      );
    });
  }

  Widget _handleButtonDownload() {
    // return TextButton(
    //   onPressed: controller.downloadModelAIV2,
    //   style:
    //       ButtonStyle(overlayColor: WidgetStateProperty.all(primaryDarkColor)),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text('Tải về',
    //           style: styleSmallBold.copyWith(color: primaryDarkColor)),
    //     ],
    //   ),
    // );
    return Obx(() {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (controller.downloadStartNotifier.value == true &&
            controller.downloadingNotifier.value == false)
          OutlinedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text("Tải về"),
            onPressed: controller.downloadResume,
            style: ElevatedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: primaryLightColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                foregroundColor: primaryColor),
          )
        else
          OutlinedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text("Huỷ bỏ"),
            onPressed: controller.downloadCancel,
            style: ElevatedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: primaryLightColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv5),
                ),
                foregroundColor: primaryColor),
          )
      ]);
    });
  }

  Widget _handleButton() {
    return WidgetButton(
        title: 'Trở lại màn hình chính', onPressed: controller.backHome);
  }

  Widget _handleResult() {
    //if (NetworkService.connectionType == Network.none ||
    // controller.downloadStartNotifier.value == false) {
    Text msgText = Text(controller.messageResult.value,
        style: const TextStyle(color: Color.fromARGB(255, 176, 46, 37)));
    Icon iconRes = const Icon(
      Icons.info,
      color: Color.fromARGB(255, 176, 46, 37),
    );
    if (controller.messageResultCode.value == ApiConstants.responseSuccess) {
      msgText = Text(controller.messageResult.value,
          style: const TextStyle(color: Color.fromARGB(255, 4, 111, 15)));
      iconRes = const Icon(
        
        Icons.check_circle_outline,
        color: Color.fromARGB(255, 4, 111, 15),
        size: 32,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 32,
        ),
        if (controller.messageResult.value != '' &&
            controller.messageResultCode.value == ApiConstants.responseSuccess)
          iconRes,
        msgText,
      ],
    );
    //}
    //return const SizedBox();
  }
}
