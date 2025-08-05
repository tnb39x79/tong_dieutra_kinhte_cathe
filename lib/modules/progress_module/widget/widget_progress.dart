import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetProgress extends StatelessWidget {
  const WidgetProgress({
    super.key,
    required this.title,
    required this.count,
    required this.onPressed,
  });

  final String title;
  final int count;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        
        padding: const EdgeInsets.all(AppValues.padding/2),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _titleTop(),
        _titleBottom(),
      ],
    );
  }
 

  Widget _titleTop() {  
    return Text(title, style: styleMedium500);
  }

  Widget _titleBottom() {
    return RichText(
      text: TextSpan(
        text: 'count'.tr,
        style: styleMedium.copyWith(color: primaryColor, fontWeight: FontWeight.w400),
        children: <TextSpan>[
          TextSpan(
            text: '$count',
            style: styleMedium500.copyWith(color: warningColor),
          ),
        ],
      ),
    );
  }
}
