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
    return LoadingFullScreen(
        loading: controller.loadingSubject,
        child: Scaffold(
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
          body: _buildBody(),
        ));
  }

  Widget appBarTitle() {
    var t = 'status_active'.tr;
    var s =
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
            subtitle: Text(s, style: const TextStyle(color: Colors.white)),
            titleAlignment: ListTileTitleAlignment.center,
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
                minHeight: viewportConstraints.maxHeight - kToolbarHeight + 20,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() => wTitle()),
                    const SizedBox(height: 8),
                    Expanded(child: Obx(() => _question())), 
                    _button()
                  ],
                ),
              )));
    });
  }

  Widget wTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(style: styleMediumBold, children: [
          TextSpan(
              text: 'Tên cơ sở: ',
              style: styleMediumBold.copyWith(color: blackText,height: textHeightNormal)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKD.value.tenCoSo ?? ''.toUpperCase()}',
              style: styleMediumBold.copyWith(color: primaryColor,height: textHeightNormal))
        ])),
        RichText(
            text: TextSpan(style: styleMediumBold, children: [
          TextSpan(
              text: 'Tên chủ cơ sở: ',
              style: styleMediumBold.copyWith(color: blackText,height: textHeightNormal)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKD.value.tenChuCoSo ?? ''.toUpperCase()}',
              style: styleMediumBold.copyWith(color: primaryColor,height: textHeightNormal))
        ])),
        RichText(
            text: TextSpan(style: styleMediumBold, children: [
          TextSpan(
              text: 'Ngành sản phẩm: ',
              style: styleMediumBold.copyWith(color: blackText,height: textHeightNormal)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKDNganhSanPham.value.maNganh ?? ''} - ${controller.tblBkCoSoSXKDNganhSanPham.value.tenNganh ?? ''}.',
              style: styleMediumBold.copyWith(color: primaryColor,height: textHeightNormal))
        ])),
        Divider(),
        const SizedBox(height: 8),
        Text(
          'Chọn tình trạng hoạt động của sơ cở:',
          style: styleLargeBold.copyWith(color: blackText,height: textHeightNormal),
        )
      ],
    );
  }

  Widget wTitleV() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(style: styleMediumBold, children: [
            TextSpan(
                text:
                    'Cơ sở "${controller.tblBkCoSoSXKD.value.tenCoSo!.toUpperCase()}" của ${controller.tblBkCoSoSXKD.value.tenChuCoSo} đang SXKD ngành sản phẩm là: ',
                style: styleMediumBold.copyWith(color: blackText)),
            TextSpan(
                text:
                    '${controller.tblBkCoSoSXKDNganhSanPham.value.maNganh} - ${controller.tblBkCoSoSXKDNganhSanPham.value.tenNganh}.',
                style: styleMediumBold.copyWith(color: primaryColor))
          ])),
          const SizedBox(height: 16),
          Text(
            'Chọn tình trạng hoạt động của sơ cở:',
            style: styleMediumBold.copyWith(color: blackText),
          )
        ]);
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
