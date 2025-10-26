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
    return Scaffold(
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
      body: LoadingFullScreen(
        loading: controller.loadingSubject,
        child: _buildBody(),
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.all(AppValues.padding),
      child: Column(
        children: [
          Obx(() => wTitle()),
          const SizedBox(height: 8),
          Expanded(child: Obx(() => _question())),
          _button()
        ],
      ),
    );
  }

  Widget wContainer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppValues.padding / 8,
        0,
        AppValues.padding / 8,
        AppValues.padding / 8,
      ),
      padding: const EdgeInsets.all(0),
      width: Get.width,
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 1, color: backgroundColorSync),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppValues.borderLv2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: wTitle()),
        ],
      ),
    );
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
              style: styleMediumBold.copyWith(color: blackText)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKD.value.tenCoSo ?? ''.toUpperCase()}',
              style: styleMediumBold.copyWith(color: primaryColor))
        ])),
        RichText(
            text: TextSpan(style: styleMediumBold, children: [
          TextSpan(
              text: 'Tên chủ cơ sở: ',
              style: styleMediumBold.copyWith(color: blackText)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKD.value.tenChuCoSo ?? ''.toUpperCase()}',
              style: styleMediumBold.copyWith(color: primaryColor))
        ])),
        RichText(
            text: TextSpan(style: styleMediumBold, children: [
          TextSpan(
              text: 'Ngành sản phẩm: ',
              style: styleMediumBold.copyWith(color: blackText)),
          TextSpan(
              text:
                  '${controller.tblBkCoSoSXKDNganhSanPham.value.maNganh ?? ''} - ${controller.tblBkCoSoSXKDNganhSanPham.value.tenNganh ?? ''}.',
              style: styleMediumBold.copyWith(color: primaryColor))
        ])),
        Divider(),
        const SizedBox(height: 8),
        Text(
          'Chọn tình trạng hoạt động của sơ cở:',
          style: styleLargeBold.copyWith(color: blackText),
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
