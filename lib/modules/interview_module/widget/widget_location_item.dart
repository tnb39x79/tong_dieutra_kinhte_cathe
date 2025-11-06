import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetLocationItem extends StatelessWidget {
  const WidgetLocationItem({
    super.key,
    required this.index,
    required this.title,
    required this.vilage, 
    required this.onPressed,
    this.textStyleSub
  });

  final String index;
  final String title;
  final String vilage;
  final TextStyle? textStyleSub;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding,
          0,
          AppValues.padding,
          AppValues.padding,
        ),
        padding: const EdgeInsets.all(AppValues.padding),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
            _iconActions(),
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

  Widget _iconActions() {
    return   Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26.withValues(alpha: 0.3));
  }

  Widget _titleTop() {
    return RichText(
      text: TextSpan(
        text: index.length == 1 ? '0$index' : index,
        style: styleMediumBold.copyWith(color: greyBorder),
        children: <TextSpan>[
          TextSpan(
            text: '  $title',
            style: styleMediumBold.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _titleBottom() {
    return RichText(
      text: TextSpan(
        text: '',
        style: styleMedium.copyWith(
            color: primaryColor, fontWeight: FontWeight.w400),
        children: <TextSpan>[
          TextSpan(
            text: vilage,
            style: textStyleSub?? styleMediumBold.copyWith(color: warningColor),
          ),
        ],
      ),
    );
  }
}
