import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetGroupMenuInterview extends StatelessWidget {
  const WidgetGroupMenuInterview(
      {super.key,
      required this.onPressed,
      required this.title,
      this.subTitle,
      this.showIconAction,
      this.borderRadiusGeometry,
      this.wPadding,
      this.bgColor});

  final Function() onPressed;
  final String title;
  final String? subTitle;
  final bool? showIconAction;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final EdgeInsetsGeometry? wPadding;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          0,
          0,
          0,
          0,
        ),
        padding: wPadding?? const EdgeInsets.all(AppValues.padding),
        width: Get.width,
        decoration: BoxDecoration(
          color:bgColor?? Colors.white,
          borderRadius:borderRadiusGeometry?? BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
            if (showIconAction != null && showIconAction == true)
              _iconActions(),
          ],
        ),
      ),
    );
  }

  Widget _iconActions() {
    return const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26);
  }

  Widget _info() {
    // return Text(title, style: styleMediumBold.copyWith(height: 1.0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: styleLargeBold600.copyWith(height: 1.0)),
        _titleBottom(),
      ],
    );
  }

  Widget _titleBottom() {
    if (subTitle != null && subTitle != "") {
      return RichText(
        text: TextSpan(
          text: subTitle,
          style: styleMediumW400.copyWith(color: warningColor),
        ),
      );
    }
    return const SizedBox();
  }
}
