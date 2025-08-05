import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';

class WidgetItemHeader extends StatelessWidget {
  const WidgetItemHeader({
    Key? key,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.name,
    required this.icon,
    required this.isSelected,
  }) : super(key: key);

  final double height;
  final double width;
  final String name;
  final String icon;
  final bool isSelected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Container(
              width: width,
              height: height,
              child: Image.asset(
                icon,
                color:
                    isSelected ? Colors.white : const Color(0xFFFFFFFF).withOpacity(0.65),
              ),
              decoration: BoxDecoration(
                  color: isSelected ? primaryLightColor : primaryDarkColor,
                  borderRadius: BorderRadius.circular(AppValues.borderLv3))),
        ),
        Text(name, style: styleSmallBold.copyWith(color: Colors.white)),
      ],
    );
  }
}
