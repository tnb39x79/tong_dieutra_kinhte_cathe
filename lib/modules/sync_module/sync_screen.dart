import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_images.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_module.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/widget/w_title_header.dart';
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_result.dart';
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
    // return PopScope(
    //   canPop: false,
    //   onPopInvokedWithResult: (didPop, result) async {
    //     if (didPop) {
    //       return;
    //     }
    //   },
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Đồng bộ dữ liệu'),
    //       automaticallyImplyLeading: false,
    //       centerTitle: true,
    //     ),
    //     backgroundColor: Colors.white,
    //     body: _buildBody(),
    //   ),
    // );
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
                      height: 10,
                    ),
                    Center(
                      child: Column(
                        children: [
                          _handleProgressBar(),
                          const SizedBox(),
                          syncResult(),
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

  Widget syncResult() {
    if (controller.responseCode.value == ApiConstants.responseSuccess) {
      return Column(
        children: [
          Text(
            'Đồng bộ hoàn thành',
            style: styleSmallBold.copyWith(color: primaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            controller.responseMessage.value,
            style: styleSmall.copyWith(color: greyColor),
            textAlign: TextAlign.center,
          ),
          syncDetailResult()
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
      return Column(
        children: [
          Text(
            controller.responseMessage.value,
            style: styleSmallBold.copyWith(color: errorColor),
            textAlign: TextAlign.center,
          ),
          syncDetailResult()
        ],
      );
    }

    return Text(
      'warning_sync'.tr,
      style: styleSmallBold.copyWith(color: greyColor),
      textAlign: TextAlign.center,
    );
  }

  Widget syncDetailResult() {
    return ListView.builder(
      itemCount: controller.syncResults!.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 0),
      itemBuilder: (context, index) {
        int count = 0;
        String syncResultTitle = '';
        var isSuccess = controller.syncResults[index].isSuccess;
        var syncResultItems = controller.syncResults[index].syncResultItems;

        if (isSuccess == true) {
          count = controller.syncResults[index].countSuccess!;
          syncResultTitle = 'Đồng bộ thành công';
        } else {
          count = controller.syncResults[index].countFailed!;
          syncResultTitle = 'Đồng bộ lỗi';
        }
        if (syncResultItems != null &&
            syncResultItems.isNotEmpty &&
            count > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              WTitleHeader(titleHeader: syncResultTitle, isSuccess: isSuccess!),
              Container(
                margin: const EdgeInsets.fromLTRB(
                  AppValues.padding / 8,
                  0,
                  AppValues.padding / 8,
                  AppValues.padding / 8,
                ),
                padding: const EdgeInsets.all(0),
                width: Get.width,
                decoration: BoxDecoration(
                  border: syncResultTitle == 'Đồng bộ lỗi'
                      ? BoxBorder.all(width: 1, color: errorColor)
                      : BoxBorder.all(width: 1, color: backgroundColorSync),
                  color: backgroundColorSync,
                  borderRadius: BorderRadius.circular(AppValues.borderLv2),
                  boxShadow: [
                    BoxShadow(
                      color: syncResultTitle == 'Đồng bộ lỗi'
                          ? Colors.grey.shade200
                          : Colors.grey.shade100,
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        wCardSync(syncResultItems, isSuccess),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget wCardSync(List<SyncResultItem>? syncResultItems, bool isSuccess) {
    if (syncResultItems != null && syncResultItems.isNotEmpty) {
      return ListView.builder(
        itemCount: syncResultItems.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding / 4),
        itemBuilder: (context, index) {
          var maDT = syncResultItems[index].maDoiTuongDT;
          var tenDT = syncResultItems[index].tenDoiTuongDT;
          var syncResultDetail = syncResultItems[index].syncResultDetailItems;
          if (syncResultDetail != null && syncResultDetail.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (index > 0) const SizedBox(height: 16),
                ListTile(
                  tileColor: Colors.blue[100],
                  title: Text(
                    tenDT!,
                    style: styleLargeBold.copyWith(color: primaryColor),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                wCardSyncItem(syncResultDetail!, maDT!, isSuccess)
              ],
            );
          }
          return const SizedBox();
        },
      );
    }
    return Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding / 8,
          0,
          AppValues.padding / 8,
          AppValues.padding / 8,
        ),
        padding: const EdgeInsets.all(AppValues.padding / 8),
        width: Get.width,
        decoration: BoxDecoration(
          color: backgroundColorSync,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: const Text('Không'));
  }

  Widget wCardSyncItem(List<SyncResultDetailItem>? syncResultDetailItems,
      int maDT, bool isSuccess) {
    if (syncResultDetailItems != null && syncResultDetailItems.isNotEmpty) {
      return ListView.builder(
        itemCount: syncResultDetailItems.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: AppValues.padding / 4),
        itemBuilder: (context, index) {
          var titleH =
              ' ${index + 1}. ${syncResultDetailItems[index].toString()}';
          var errorMsg = '${syncResultDetailItems[index].errorMessage}';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: Text(titleH),
                subtitle: (errorMsg != null &&
                        errorMsg != 'null' &&
                        errorMsg != '')
                    ? Text(errorMsg,
                        style: isSuccess == false
                            ? styleSmall.copyWith(color: errorColor)
                            : styleSmall.copyWith(color: Colors.grey))
                    : null,
              )
            ],
          );
        },
      );
    }
    return Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding / 8,
          0,
          AppValues.padding / 8,
          AppValues.padding / 8,
        ),
        padding: const EdgeInsets.fromLTRB(AppValues.padding,
            AppValues.padding / 4, AppValues.padding, AppValues.padding / 4),
        width: Get.width,
        decoration: BoxDecoration(
          color: backgroundColorSync,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: maDT == 4
            ? Text('0 Cơ sở',
                style: isSuccess
                    ? styleSmall.copyWith(color: successColor)
                    : styleSmall.copyWith(color: errorColor))
            : Text('0 Hộ',
                style: isSuccess
                    ? styleSmall.copyWith(color: successColor)
                    : styleSmall.copyWith(color: errorColor)));
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
    } else if (controller.responseCode.value != ApiConstants.responseSuccess &&
        controller.endSync.value == true) {
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
        width: 48,
      );
    } else if (controller.responseCode.value == ApiConstants.duLieuDongBoRong) {
      return const Image(color: Colors.grey,
        image: AssetImage(
          AppImages.uploadEmpty
        ),
        width: 48,
      );
    } else if (controller.responseCode.value == ApiConstants.requestTimeOut) {
      return const Image(
        image: AssetImage(
          AppImages.uploadTimeout,
        ),
        width: 48,
      );
    } else {
      return const Image(
        image: AssetImage(
          AppImages.uploadError,
        ),
        width: 48,
      );
    }
  }
}
