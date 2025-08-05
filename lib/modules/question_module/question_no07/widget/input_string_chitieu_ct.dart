import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/general_information/general_information_controller.dart';
import 'package:gov_statistics_investigation_economic/resource/model/model.dart';

class InputStringChiTieuCT extends StatefulWidget {
  const InputStringChiTieuCT(
      {required this.chiTieuCot,
      required this.onChange,
      this.validator,
      this.value,
      this.enable = true,
      this.subName,
      this.maxLine = 1,
      this.chiTieuDong,
      this.minLen,
      this.maxLen,
      this.keyboardType,
      this.inputFormatters,
      this.enableTitle = true,
      this.stt,
      super.key});

  final dynamic chiTieuCot;
  final Function(String?)? onChange;
  final String? Function(String?)? validator;
  final String? value;
  final bool enable;
  final String? subName;
  final int maxLine;
  final dynamic chiTieuDong;
  final int? maxLen;
  final int? minLen;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableTitle;
  final int? stt;

  @override
  InputStringChiTieuCTState createState() => InputStringChiTieuCTState();
}

class InputStringChiTieuCTState extends State<InputStringChiTieuCT> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();

  final GeneralInformationController generalInformationController = Get.find();

  @override
  void initState() {
    if (widget.value != null) {
      _controller.text = widget.value.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        wTextQuesion(),
        const SizedBox(height: 4),
        WidgetFieldInput(
          controller: _controller,
          enable: widget.enable,
          hint: 'Nhập vào đây',
          validator: widget.validator,
          onChanged: (String? value) =>
              widget.onChange!(value != "" ? value : null),
          maxLine: widget.maxLine,
          maxLength: widget.maxLen,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          // suffix: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       wTextDvt(),
          //     ],
          //   ),
          // ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
 

  Widget wTextQuesion() {
    var txt = textTenChiTieu();
    final split = txt.split(';');

    if (txt.contains(';')) {
      return RichTextQuestion(
        split[0],
        level: 3,
        notes: split[1],
        enable: widget.enableTitle,
      );
    } else {
      if (widget.stt != null && widget.stt! > 0) {
        txt = '$txt ${widget.stt}';
      }
      return RichTextQuestion(
        txt,
        level: 3,
        enable: widget.enableTitle,
      );
    }
  }

  Widget wTextDvt() {
    return Text(
      textDvt(),
      style: TextStyle(color: Theme.of(context).hintColor),
    );
  }

  String textTenChiTieu() {
    if (widget.chiTieuCot is ChiTieuModel) {
      ChiTieuModel wChiTieu = widget.chiTieuCot as ChiTieuModel;
      return wChiTieu.tenChiTieu ?? '';
    } else if (widget.chiTieuCot is ChiTieuDongModel) {
      ChiTieuDongModel wChiTieu = widget.chiTieuCot as ChiTieuDongModel;
      return wChiTieu.tenChiTieu ?? '';
    } else if (widget.chiTieuCot is ChiTieuIntModel) {
      ChiTieuIntModel wChiTieu = widget.chiTieuCot as ChiTieuIntModel;
      return wChiTieu.tenChiTieu ?? '';
    } else {
      return '';
    }
  }

  String textDvt() {
    if (widget.chiTieuCot is ChiTieuModel) {
      ChiTieuModel wChiTieu = widget.chiTieuCot as ChiTieuModel;
      return wChiTieu.dVT ?? '';
    } else if (widget.chiTieuCot is ChiTieuDongModel) {
      ChiTieuDongModel wChiTieu = widget.chiTieuCot as ChiTieuDongModel;
      return wChiTieu.dVT ?? '';
    } else if (widget.chiTieuCot is ChiTieuIntModel) {
      ChiTieuIntModel wChiTieu = widget.chiTieuCot as ChiTieuIntModel;
      return wChiTieu.tenChiTieu ?? '';
    } else {
      return '';
    }
  }

  TextStyle _getStyle() {
    switch (3) {
      case 2:
        return styleLargeBold;
      case 1:
        return styleLargeBold;

      default:
        return styleMedium;
    }
  }

  Widget richText(String text, {int level = 3}) {
    String textTmp = text;
      return Text(_handleText(text), style: _getStyle());
  }

  String _handleText(String text) {
    String textTmp = text;
 
    return textTmp;
  }
}
