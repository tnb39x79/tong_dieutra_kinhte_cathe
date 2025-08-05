import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetButtonBorder extends StatelessWidget {
  const WidgetButtonBorder(
      {super.key, required this.onPressed, required this.title, this.btnColor});
  final Function() onPressed;
  final String title;
  final Color? btnColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppValues.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.borderLv5),
          ),
          side: BorderSide(width: 1, color: btnColor ?? primaryColor),
        ),
        child: Text(title,
            style: styleSmallBold.copyWith(color: btnColor ?? primaryColor)),
      ),
    );
  }
}
