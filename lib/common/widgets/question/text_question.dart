import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_module.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class TextQuestion extends StatelessWidget {
  TextQuestion(this.text, {this.level = 2, this.product});

  final String text;
  final int level; // the level question, is have range = [1,2,3,4,5,6,7,8]
  final ProductModel? product;
  final GeneralInformationController generalInformationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: _getMargin(), bottom: _getMargin() - 4),
      child: Text(_handleText(), style: _getStyle()),
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
