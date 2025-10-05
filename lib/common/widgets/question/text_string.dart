import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/resource/model/model.dart';

class TextString extends StatefulWidget {
  const TextString(
      {required this.question,
      this.value,
      this.enable = true,
      this.subName,
      this.maxLine = 1,
      this.warningText,
      this.textStyle,
      this.borderColor,
      super.key});

  final QuestionCommonModel question;
  final String? value;
  final bool enable;
  final String? subName;
  final int maxLine;
  final String? warningText;
  final TextStyle? textStyle;
  final Color? borderColor;
  @override
  TextStringState createState() => TextStringState();
}

class TextStringState extends State<TextString> {
  // ignore: prefer_final_fields

  @override
  void initState() {
    if (widget.value != null) {}
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          widget.question.tenCauHoi ?? '',
          level: widget.question.cap ?? 2,
        ),
        IntrinsicHeight(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                  color: backgroundDisableColor,
                  border: Border.all(
                    color: widget.borderColor?? primaryLightColor,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      5.0))), // Adds a gradient background and rounded corners to the container
              child: Text(
                widget.value ?? '',
                style: widget.textStyle ??
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackText,
                    ),
              )),
        ),
        wWarningText(),
        const SizedBox(height: 12),
      ],
    );
  }

  String _handleText() {
    var mainName = widget.question.tenCauHoi ?? '';

    if (widget.subName != null) {
      if (mainName.contains('[')) {
        String string1 = mainName.substring(0, mainName.indexOf('['));
        String string2 = widget.subName ?? '';
        String string3 = mainName.substring(mainName.indexOf(']') + 1);
        return string1 + string2 + string3;
      }
    }

    return mainName;
  }

  Widget buildSuffix() {
    var suff = widget.question.dVT ?? '';
    if (suff != '') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.question.dVT ?? '',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget wWarningText() {
    if (widget.warningText != null && widget.warningText != '') {
      return Text(
        widget.warningText!,
        style: const TextStyle(color: Colors.orange),
      );
    }
    return const SizedBox();
  }
}
