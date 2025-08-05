import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

enum SingingCharacter { lafayette, jefferson }

class YesNoQuestion extends StatefulWidget {
  const YesNoQuestion({
    super.key,
    required this.onChange,
    required this.question,
    this.child,
    this.value,
    this.disable = false,
  });

  final QuestionCommonModel question;
  final Function(int) onChange;
  final Widget? child;
  final int? value;
  final bool disable;
  @override
  YesNoQuestionState createState() => YesNoQuestionState();
}

class YesNoQuestionState extends State<YesNoQuestion> {
  int _value = -1;
  @override
  void initState() {
    log('${widget.value}');
    if (widget.value != null) {
      _value = widget.value ?? -1;
      log('$_value');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichTextQuestion(widget.question.tenCauHoi ?? ''),
        CheckBoxCircle(
            text: 'Có',
            index: 1,
            currentIndex: _value,
            showIndex: false,
            styles: styleMediumBold.copyWith(
                color: blackText, height: 1.0, fontWeight: FontWeight.w600),
            onPressed: (value) {
              widget.onChange(value);
              if (widget.disable == false) {
                setState(() {
                  _value = value;
                });
              }
            }),
        CheckBoxCircle(
            text: 'Không',
            index: 0,
            currentIndex: _value,
            showIndex: false,
            styles: styleMediumBold.copyWith(
                color: blackText, height: 1.0, fontWeight: FontWeight.w600),
            onPressed: (value) {
              widget.onChange(value);
              if (widget.disable == false) {
                setState(() {
                  _value = value;
                });
              }
            }),
        if (_value == 1) widget.child ?? Container()
      ],
    );
  }
}
