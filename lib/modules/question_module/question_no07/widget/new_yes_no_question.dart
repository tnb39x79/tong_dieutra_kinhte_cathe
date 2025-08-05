import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class NewYesNoQuestion extends StatelessWidget {
  const NewYesNoQuestion({
    super.key,
    required this.onChange,
    required this.question,
    this.child,
    this.value,
  });

  final QuestionCommonModel question;
  final Function(int) onChange;
  final Widget? child;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextQuestion(question.tenCauHoi ?? ''),
        CheckBoxCircle(
            text: 'Có',
            index: 1,
            currentIndex: value ?? -1,
            showIndex: false,
            styles: styleMediumBold.copyWith(
                color: blackText, height: 1.0, fontWeight: FontWeight.w600),
            onPressed: (value) {
              onChange(value);
            }),
        CheckBoxCircle(
            text: 'Không',
            index: 2,
            currentIndex: value ?? -1,
            showIndex: false,
            styles: styleMediumBold.copyWith(
                color: blackText, height: 1.0, fontWeight: FontWeight.w600),
            onPressed: (value) {
              onChange(value);
            }),
        if (value == 1) child ?? Container()
      ],
    );
  }
}
