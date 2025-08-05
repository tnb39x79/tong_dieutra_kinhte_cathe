import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetMenuInterview extends StatelessWidget {
  const WidgetMenuInterview({
    Key? key,
    required this.onPressed,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  final Function() onPressed;
  final String title;
  final String? subTitle;

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

  Widget _iconActions() {
    return const Icon(Icons.arrow_forward_ios_rounded, color: greyBorder);
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
    if(subTitle!=null && subTitle!=""){
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
