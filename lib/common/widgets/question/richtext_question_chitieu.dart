import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:gov_statistics_investigation_economic/config/config.dart'; 
import 'package:gov_statistics_investigation_economic/modules/question_module/question_module.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class RichTextQuestionChiTieu extends StatelessWidget {
  RichTextQuestionChiTieu(this.text,
      {this.level = 2,
      this.prefixText,
      this.seperateSign,
      this.product,
      this.notes,
      super.key});

  final String text;
  final String? prefixText;
  final String? seperateSign;
  final int level; // the level question, is have range = [1,2,3,4,5,6,7,8]
  final ProductModel? product;
  final String? notes;

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
        return styleLargeBold;
      case 1:
        return styleLargeBold;

      default:
        return styleMedium;
    }
  }

  Widget richText() {
    String textTmp = text;
     
      var txt = _handleText();
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
            if (prefixText != null && prefixText != '')
              TextSpan(
                text: level == 1 ? prefixText!.toUpperCase() : prefixText,
                style: (level == 1 || level == 2)
                    ? const TextStyle(
                        fontSize: fontLarge,
                        height: textHeight,
                        fontFamily: inter,
                        fontWeight: FontWeight.w700,
                        color: warningColor)
                    : const TextStyle(
                        fontSize: fontMedium,
                        height: textHeight,
                        fontFamily: inter,
                        fontWeight: FontWeight.w600,
                        color: warningColor),
              ),
            if (prefixText != null &&
                prefixText != '' &&
                seperateSign != null &&
                seperateSign != '')
              TextSpan(
                text: level == 1 ? seperateSign!.toUpperCase() : seperateSign,
                style: (level == 1 || level == 2)
                    ? const TextStyle(
                        fontSize: fontLarge,
                        height: textHeight,
                        fontFamily: inter,
                        fontWeight: FontWeight.w700,
                        color: blackText)
                    : const TextStyle(
                        fontSize: fontMedium,
                        height: textHeight,
                        fontFamily: inter,
                        fontWeight: FontWeight.w500,
                        color: blackText),
              ),
            TextSpan(
              text: txt,
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

      //return Text(_handleText(), style: _getStyle());
      // if (notes != null && notes != '') {
      //   return Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(_handleText(), style: _getStyle()),
      //         Text(
      //           notes!,
      //           textAlign: TextAlign.left,
      //           style: styleSmall,
      //         )
      //       ]);
      // } else {
      //   return Text(_handleText(), style: _getStyle());
      // }
    
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
