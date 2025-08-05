import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_images.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_module.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/api.dart';

class SyncScreen extends GetView<SyncController> {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đồng bộ dữ liệu'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
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
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Column(
                        children: [
                          _handleProgressBar(),
                          const SizedBox(),
                          _handleText(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    _handleButton()
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _handleProgressBar() {
    //if (controller.endSync.value) return const SizedBox();
    //edit: 07/06/2024; thêm ảnh sau khi sync thành công
    if (controller.endSync.value) {
      return Column(
        children: [
          imgResult(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const Image(
            image: AssetImage(
              AppImages.uploadAnimation,
            ),
            width: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  // value: controller.progress.value / 100,
                  color: (controller.responseCode.value !=
                              ApiConstants.responseSuccess &&
                          controller.responseCode.value !=
                              ApiConstants.duLieuDongBoRong)
                      ? errorColor
                      : primaryColor,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _handleText() {
    if (controller.responseCode.value == ApiConstants.responseSuccess) {
      return Column(
        children: [
          Text(
            'Đồng bộ thành công',
            style: styleSmallBold.copyWith(color: primaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            controller.responseMessage.value,
            style: styleSmall.copyWith(color: greyColor),
            textAlign: TextAlign.center,
          )
        ],
      );
    } else if (controller.responseCode.value == ApiConstants.duLieuDongBoRong) {
      return Column(
        children: [
          Text(
            controller.responseMessage.value,
            style: styleSmall.copyWith(color: blackText),
            textAlign: TextAlign.center,
          )
        ],
      );
    }
    if (controller.responseCode.value != ApiConstants.responseSuccess) {
      return Text(
        controller.responseMessage.value,
        style: styleSmallBold.copyWith(color: errorColor),
        textAlign: TextAlign.center,
      );
    }

    return Text(
      'warning_sync'.tr,
      style: styleSmallBold.copyWith(color: greyColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _handleButton() {
    log('Result Sync = ${controller.responseCode.value}; isSuccess= ${controller.responseMessage.value}');
    if (controller.responseCode.value == ApiConstants.responseSuccess) {
      return Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WidgetButton(
                title: 'Trở lại màn hình chính',
                onPressed: controller.backHome),
          )),
        ],
      );
    } else if (controller.responseCode.value == ApiConstants.duLieuDongBoRong) {
      return Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WidgetButton(
                title: 'Trở lại màn hình chính',
                onPressed: controller.backHome),
          )),
        ],
      );
    } else if (controller.responseCode.value != ApiConstants.responseSuccess && controller.endSync.value==true) {
      return Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: WidgetButton(
                    title: 'Trở lại màn hình chính',
                    onPressed: controller.backHome),
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WidgetButton(
              title: 'Thử lại',
              onPressed: controller.syncData,
              background: errorColor,
            ),
          ))
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WidgetButton(
                title: 'Trở lại màn hình chính',
                onPressed: controller.backHome),
          )),
        ],
      );
    }
  }

  Widget imgResult() {
    if (controller.responseCode.value == ApiConstants.responseSuccess) {
      return const Image(
        image: AssetImage(
          AppImages.uploadSuccess,
        ),
        width: 200,
      );
    } else if (controller.responseCode.value == ApiConstants.duLieuDongBoRong) {
      return const Image(
        image: AssetImage(
          AppImages.uploadEmpty,
        ),
        width: 200,
      );
    } else if (controller.responseCode.value == ApiConstants.requestTimeOut) {
      return const Image(
        image: AssetImage(
          AppImages.uploadTimeout,
        ),
        width: 200,
      );
    } else {
      return const Image(
        image: AssetImage(
          AppImages.uploadError,
        ),
        width: 80,
      );
    }
  }
}
