import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/utils/app_enum.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
 

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    super.key,
    this.iconCenter,
    required this.title,
    required this.onPressed,
    this.background,
    this.buttonType,
  });

  final Widget? iconCenter;
  final String title;
  final Function() onPressed;
  final Color? background;
  final BtnType? buttonType;
  @override
  Widget build(BuildContext context) {
    if (buttonType == BtnType.outline) {
      return outlineButton();
    }
    return Container(
      height: AppValues.buttonHeight,
      decoration: BoxDecoration(
        color: background ?? primaryColor,
        borderRadius: BorderRadius.circular(AppValues.borderLv5),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(splashColorButton)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconCenter ?? const SizedBox(),
            iconCenter != null ? const SizedBox(width: 8) : const SizedBox(),
            Text(title, style: styleSmallBold.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget outlineButton() {
    return Container(
      height: AppValues.buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(AppValues.borderLv5),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(splashColorButton)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconCenter ?? const SizedBox(),
            iconCenter != null ? const SizedBox(width: 8) : const SizedBox(),
            Text(title, style: styleSmallBold.copyWith(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
