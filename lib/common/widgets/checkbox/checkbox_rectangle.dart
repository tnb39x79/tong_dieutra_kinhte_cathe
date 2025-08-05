import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_icons.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';

class CheckBoxRectangle extends StatelessWidget {
  const CheckBoxRectangle({
    Key? key,
    required this.text,
    required this.index,
    required this.currentIndex,
    required this.onPressed,
    this.isSelected = false,
    this.showIndex = true,
  }) : super(key: key);

  final String text;
  final int index;
  final int currentIndex;
  final Function(int) onPressed;
  final bool showIndex;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.padding / 2),
        child: Row(
          children: [
            _icon(),
            const SizedBox(width: AppValues.padding),
            Expanded(child: _content())
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color:
            isSelected || currentIndex == index ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color:
              isSelected || currentIndex == index ? primaryColor : greyCheckBox,
        ),
      ),
      child: Image.asset(AppIcons.icTick),
    );
  }

  Widget _content() {
    String cText = showIndex ? '${index + 1}.  $text' : text;

    return Text(
      cText,
      style: styleMediumBold.copyWith(
          color: blackText, height: 1.0, fontWeight: FontWeight.w600),
    );
  }
}
