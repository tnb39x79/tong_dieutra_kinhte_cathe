import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_module.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class RichTextQuestion extends StatelessWidget {
  RichTextQuestion(this.text,
      {this.level = 2,
      this.product,
      this.notes,
      this.enable = true,
      this.stt,
      this.subText,
      this.moTaSanPham,
      super.key});

  final String text;
  final int level; // the level question, is have range = [1,2,3,4,5,6,7,8]
  final dynamic product;
  final String? notes;
  final bool? enable;
  final int? stt;
  final String? subText;
  final String? moTaSanPham;

  final GeneralInformationController generalInformationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: _getMargin(), bottom: _getMargin() - 4),
        child: richText() //Text(_handleText(), style: _getStyle()),

        );
  }

  TextStyle _getStyle() {
    switch (level) {
      case 2:
        return styleLargeBold.copyWith(
            color: enable! ? Colors.black : greyColor);
      case 1:
        return styleLargeBold.copyWith(
            color: enable! ? Colors.black : greyColor);

      default:
        return styleMedium.copyWith(color: enable! ? Colors.black : greyColor);
    }
  }

  Widget richText() {
    // return Text(_handleText(), style: _getStyle());
    String textTmp = text;
    var hasSubText = text.toLowerCase().contains('[...]');

    if (hasSubText) {
      textTmp = textTmp.replaceAll('[...]', '#');
      var arr = textTmp.split('#');
      String firstPart = arr[0]; // textTmp.substring(0, textTmp.indexOf('['));
      String secondPart = arr[1];
      return RichText(
          text: TextSpan(
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
              children: [
            TextSpan(
              text: firstPart,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
            ),
            TextSpan(
              text: subText,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: primaryColor)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
            ),
            TextSpan(
              text: secondPart,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
            ),
          ]));
    } else {
      if (moTaSanPham != null && moTaSanPham != '') {
         return richTextMoTaSanpham();
      }
    }
    return Text(_handleText(), style: _getStyle());
  }

Widget richTextMoTaSanpham() { 
    String textTmp = text;
    var hasSubText = text.toLowerCase().contains('[');
    if (hasSubText) {
      textTmp = textTmp.replaceAll('[', '#').replaceAll(']', '#');
      var arr = textTmp.split('#');
      String firstPart = '${arr[0]}[';
      String secondPart = arr[1];
      String thirdPart = '] ${arr[2]}';
      if (moTaSanPham != null && moTaSanPham != '') { 
          secondPart = moTaSanPham ?? ''; 
      }
      return RichText(
          text: TextSpan(
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
              children: [
            TextSpan(
              text: firstPart,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
            ),
            TextSpan(
              text: secondPart,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: primaryColor)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
            ),
            TextSpan(
              text: thirdPart,
              style: (level == 1 || level == 2)
                  ? const TextStyle(
                      fontSize: fontLarge,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)
                  : const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
            ),
          ]));
    }
    return Text(_handleText(), style: _getStyle());
  }

  String _handleText() {
    String textTmp = text;

    return textTmp;
  }

  double _getMargin() {
    switch (level) {
      case 2:
        return 12;
      case 1:
        return 16;

      default:
        return 8;
    }
  }
}
