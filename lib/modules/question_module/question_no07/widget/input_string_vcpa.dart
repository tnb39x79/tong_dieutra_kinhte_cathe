import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/widget_field_input_vcpa.dart';
import 'package:gov_statistics_investigation_economic/resource/model/model.dart';

class InputStringVcpa extends StatefulWidget {
  const InputStringVcpa({
    required this.question,
    required this.onChange,
    this.validator,
    this.value,
    this.enable = true,
    this.subName,
    this.maxLine = 1,
    super.key,
    this.readOnly = true,
    this.onTap,
    this.focusNode,
    this.suffix,
    this.warningText,
  });

  final QuestionCommonModel question;
  final Function(String?)? onChange;
  final String? Function(String?)? validator;
  final String? value;
  final bool enable;
  final String? subName;
  final int maxLine;
  final bool? readOnly;
  final Function()? onTap;
  final FocusNode? focusNode;
  final Widget? suffix;
  final String? warningText;

  @override
  InputIntVcpaState createState() => InputIntVcpaState();
}

class InputIntVcpaState extends State<InputStringVcpa> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    if (widget.value != null) {
      _controller.text = widget.value.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
        const SizedBox(height: 4),
        WidgetFieldInputVcpa(
          controller: _controller,
          enable: widget.enable,
          hint: 'Nhập vào đây',
          validator: widget.validator,
          onChanged: (String? value) =>
              widget.onChange!(value != "" ? value : null),
          maxLine: widget.maxLine,
          suffix: wSuffix(),
          onTap: widget.onTap,
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

  Widget wSuffix() {
    if (widget.suffix != null) {
      return widget.suffix!;
    }
    if (widget.question.dVT != null) {
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
