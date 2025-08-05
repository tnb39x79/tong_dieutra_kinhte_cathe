import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
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
          subTitle: controller.currentTenDoiTuongDT,
          onPressedLeading: () => controller.onBackPage(),
          actions: const SizedBox(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07Mau.toString() ||
        controller.currentMaDoiTuongDT ==
            AppDefine.maDoiTuongDT_07TB.toString()) {
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
                label: 'HUYỆN/QUẬN/THỊ XÃ',
                textController: controller.tenHuyenController,
                textControllerEnd: controller.maHuyenController),
            fieldGroup(
                label: 'XÃ/PHƯỜNG/THỊ TRẤN',
                textController: controller.tenXaController,
                textControllerEnd: controller.maXaController),
            field(
              label: 'THÔN/ẤP/BẢN/TỔ DÂN PHỐ',
              textController: controller.tenThonController,
              enable: false,
            ),
            fieldGroup(
                label: 'ĐỊA BÀN ĐIỀU TRA',
                textController: controller.tenDiaBanController,
                textControllerEnd: controller.maDiaBanController),
            field(
                label: 'TÊN CƠ SỞ SXKD',
                textController: controller.tenCoSoController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor),
                maxLine: 3),
            field(
                label: 'MÃ NGÀNH',
                textController: controller.maNganhController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor)),
            field(
                label: 'TÊN NGÀNH',
                textController: controller.tenNganhController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor),
                maxLine: 3),
            const SizedBox(height: 24),
            WidgetButtonNext(onPressed: controller.onPressNext)
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            field(
                label: 'Tên cơ sở',
                textController: controller.tenChuHoController,
                txtTextStyle: styleMediumBold.copyWith(color: primaryColor),
                maxLine: 3),
            field(
              label: 'Địa chỉ cơ sở',
              textController: controller.diaChiChuHoController,
              enable: false,
            ),
            fieldGroup(
                label: ' Tỉnh/Thành phố',
                textController: controller.tenTinhController,
                textControllerEnd: controller.maTinhController),
            fieldGroup(
                label: ' Huyện/Quận/Thị xã',
                textController: controller.tenHuyenController,
                textControllerEnd: controller.maHuyenController),
            fieldGroup(
                label: ' Xã/Phường/Thị trấn',
                textController: controller.tenXaController,
                textControllerEnd: controller.maXaController),
            fieldGroup(
                label: ' Thôn/ấp/bản/tổ dân phố',
                textController: controller.tenThonController,
                textControllerEnd: controller.maThonController,
                enable: false),
            field(
              label: 'Thành thị/Nông thôn',
              textController: controller.ttNTController,
              enable: false,
            ),
            field(
              label: 'Cơ sở số',
              textController: controller.coSoSoGiaTriController,
              enable: false,
            ),
            // field(
            //     label: 'A1.3 Số điện thoại',
            //     textController: controller.dienThoaiController,
            //     enable: true),
            // field(
            //     label: 'A1.4 Email',
            //     textController: controller.emailController,
            //     enable: true),
            const SizedBox(height: 24),
            WidgetButtonNext(onPressed: controller.onPressNext)
          ],
        ),
      );
    }
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
      String? Function(String?)? validator,
      Function(String?)? onChanged,
      int? maxLength,
      int? maxLine,
      TextStyle? lblTextStyle,
      TextStyle? txtTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: lblTextStyle ?? styleSmall.copyWith(color: defaultText),
        ),
        // const SizedBox(height: 4),
        WidgetFieldInput(
          controller: textController,
          hint: '',
          enable: enable,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLength: maxLength,
          txtStyle: txtTextStyle,
          maxLine: maxLine,
        ),
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
}
