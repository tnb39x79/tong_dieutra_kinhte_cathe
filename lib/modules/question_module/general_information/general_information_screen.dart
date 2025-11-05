import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/recording_dialog.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input_text.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';

import 'general_information_controller.dart';

class GeneralInformationScreen extends GetView<GeneralInformationController> {
  const GeneralInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'identification_information'.tr,
          iconLeading: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          subTitle: controller.getSubTitle(),
          onPressedLeading: () => controller.onBackPage(),
          actions: const SizedBox(),
        ),
        body: Obx(_buildBody),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07Mau.toString() ||
        controller.currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07TB.toString()) {
      controller.tenCoSoController.text =
          controller.tblPhieu.value.tenCoSo ?? '';

      controller.diaChiCoSoController.text =
          controller.tblPhieu.value.diaChi ?? '';

      controller.tenChuCoSoController.text =
          controller.tblPhieu.value.tenChuCoSo ?? '';

      controller.dienThoaiController.text =
          controller.tblPhieu.value.sDTCoSo ?? '';

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldGroup(
                label: 'TỈNH/THÀNH PHỐ',
                textController: controller.tenTinhController,
                textControllerEnd: controller.maTinhController),
            fieldGroup(
                label: 'XÃ/PHƯỜNG/ĐẶC KHU',
                textController: controller.tenXaController,
                textControllerEnd: controller.maXaController),
            fieldGroup(
                label: 'THÔN/ẤP/BẢN/TỔ DÂN PHỐ',
                textController: controller.tenThonController,
                textControllerEnd: controller.maThonController),
            fieldGroup(
                label: 'ĐỊA BÀN ĐIỀU TRA',
                textController: controller.tenDiaBanController,
                textControllerEnd: controller.maDiaBanController),
            field(
              label: 'MÃ CƠ SỞ',
              textController: controller.maCoSoController,
              enable: false,
            ),
            Form(
                key: controller.formKey,
                child: Column(children: [
                  field(
                      label: 'TÊN CƠ SỞ (BIỂN HIỆU/ĐĂNG KÝ KINH DOANH)',
                      textController: controller.tenCoSoController,
                      txtTextStyle:
                          styleMediumBold.copyWith(color: primaryColor),
                      maxLine: 3,
                      enable: true,
                      onChanged: controller.onChangeTenCS,
                      validator: controller.onValidateTenCS,
                      warningText: controller.waringTenCs(),
                      sttMic: true,
                      fieldName: 'tencoso'),
                  field(
                      label: 'ĐIA CHỈ CƠ SỞ (SỐ NHÀ, ĐƯỜNG PHỐ, NGÕ, XÓM)',
                      textController: controller.diaChiCoSoController,
                      enable: true,
                      onChanged: controller.onChangeDiaChi,
                      validator: controller.onValidateDiaChi,
                      warningText: controller.waringDiaChi(),
                      sttMic: true,
                      fieldName: 'diachi'),
                  field(
                      label: 'TÊN CHỦ CƠ SỞ',
                      textController: controller.tenChuCoSoController,
                      enable: true,
                      onChanged: controller.onChangeTenChuCS,
                      validator: controller.onValidateTenChuCS,
                      warningText: controller.waringTenChuCs(),
                      sttMic: true,
                      fieldName: 'tenchucs'),
                  field(
                      label: 'SỐ ĐIỆN THOẠI LIÊN HỆ',
                      textController: controller.dienThoaiController,
                      enable: true,
                      onChanged: controller.onChangeSoDT,
                      validator: controller.onValidateSoDT,
                      warningText: controller.waringSoDienThoai()),
                ])),
            field(
                label: 'MÃ NGÀNH SẢN PHẨM CỦA CƠ SỞ BẢNG KÊ',
                textController: controller.maNganhController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor)),
            field(
                label: 'TÊN NGÀNH',
                textController: controller.tenNganhController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor),
                maxLine: 3),
         //   const SizedBox(height: 16),
            WidgetButtonNext(onPressed: controller.onPressNext)
          ],
        ),
      );
    }
    return const SizedBox();
  }

// Widget buildNganhSanPham(TableBkCoSoSXKDNganhSanPham bkSanPhams) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//   field(
//                 label: 'Mã ngành',
//                 textController: controller.tenCoSoController,
//                 txtTextStyle: styleMediumBold.copyWith(color: primaryColor)),
//     ],
//   );
// }
  Widget field(
      {required String label,
      required TextEditingController textController,
      bool enable = false,
      keyboardType = TextInputType.text,
      String? Function(String?, String)? validator,
      Function(String?)? onChanged,
      int? maxLength,
      int? maxLine,
      TextStyle? lblTextStyle,
      TextStyle? txtTextStyle,
      String? warningText,
      String? fieldName,
      bool? sttMic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: lblTextStyle ?? styleSmall.copyWith(color: defaultText),
        ),
        // const SizedBox(height: 4),
        WidgetFieldInputText(
            controller: textController,
            hint: '',
            enable: enable,
            keyboardType: keyboardType,
            validator: (v) => validator?.call(v, label),
            onChanged: onChanged,
            maxLength: maxLength,
            txtStyle: txtTextStyle,
            maxLine: maxLine,
            onMicrophoneTap:
                sttMic == true ? () => onMicrophoneTap(fieldName ?? '') : null),
        wWarningText(warningText),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget fieldGroup({
    required String label,
    required TextEditingController textController,
    TextEditingController? textControllerEnd,
    bool enable = false,
    keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
    int? maxLengthEnd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: styleSmall.copyWith(color: defaultText),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: WidgetFieldInput(
                  controller: textController,
                  hint: '',
                  enable: enable,
                  keyboardType: keyboardType,
                  validator: validator,
                  maxLength: maxLength,
                )),
            if (textControllerEnd != null)
              Expanded(
                  child: SizedBox(
                width: 100.0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: WidgetFieldInputCode(
                    controller: textControllerEnd,
                    hint: '',
                    enable: enable,
                    keyboardType: keyboardType,
                    validator: validator,
                    maxLength: maxLengthEnd,
                  ),
                ),
              )),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget wWarningText(warningText) {
    if (warningText != null && warningText != '') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 4.0, 16.0, 4.0), // Applies 16 pixels of padding on all sides
        child: Text(
          warningText!,
          style: const TextStyle(color: Colors.orange),
        ),
      );
    }
    return const SizedBox();
  }

  Widget productItems(
      {required String label, required String title, bool isBold = false}) {
    var style = isBold
        ? styleSmallBold.copyWith(color: Colors.black)
        : styleSmall.copyWith(color: defaultText);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: style,
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: style,
          ),
        ),
        // const SizedBox(height: 4),
      ],
    );
  }

  Future<void> onMicrophoneTap(String fieldName) async {
    try {
      // Show the modern recording dialog
      final recognizedText = await showRecordingDialog(
        title: 'Ghi âm câu trả lời',
        hint: 'Nhấn để bắt đầu ghi âm câu trả lời...',
        onTextRecognized: (text) {
          log('Text recognized in dialog: "$text"');
        },
      );

      // If we got text back, use it to fill the form field
      if (recognizedText != null && recognizedText.isNotEmpty) {
        // Update the form field with the recognized text
        if (fieldName == 'tencoso') {
          controller.onChangeTenCS(recognizedText, updateText: true);
        } else if (fieldName == 'diachi') {
          controller.onChangeDiaChi(recognizedText, updateText: true);
        } else if (fieldName == 'tenchucs') {
          controller.onChangeTenChuCS(recognizedText, updateText: true);
        }
      }
    } catch (e, stackTrace) {
      log('onMicrophoneTap error: $e $stackTrace');
    }
  }
}
