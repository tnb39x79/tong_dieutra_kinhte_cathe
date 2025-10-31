import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/dialogs/recording_dialog.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input_text.dart';
import 'package:gov_statistics_investigation_economic/resource/model/model.dart';

class InputString extends StatefulWidget {
  const InputString(
      {required this.question,
      required this.onChange,
      this.validator,
      this.value,
      this.enable = true,
      this.subName,
      this.maxLine = 1,
      this.warningText,
      this.textStyle,
      this.maxLength,
      this.sttMic,
      this.keyboardType,
      this.inputFormatters,
      super.key});

  final QuestionCommonModel question;
  // final Function(String?)? onChange;
  final Function(dynamic) onChange;
  final String? Function(String?)? validator;
  final String? value;
  final bool enable;
  final String? subName;
  final int maxLine;
  final int? maxLength;
  final String? warningText;
  final TextStyle? textStyle;
  final bool? sttMic;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  InputIntState createState() => InputIntState();
}

class InputIntState extends State<InputString> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();

  bool get useMicrophone => widget.sttMic ?? false;

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
        WidgetFieldInputText(
          controller: _controller,
          enable: widget.enable,
          hint: 'Nhập vào đây',
          validator: widget.validator,
          onChanged: (String? value) =>
              widget.onChange!(value != "" ? value : null),
          maxLine: widget.maxLine,
          txtStyle: widget.textStyle,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          suffix: buildSuffix(),
          onMicrophoneTap: useMicrophone ? onMicrophoneTap : null,
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

  _onChanged(String text, {bool updateText = false}) {
    if (text == "") {
      widget.onChange(null);
      return;
    }

    ///added by tuannb 09/09/2024: Giới hạn độ trường ghi chú 500 ký tự
    String result;
    result = text;
    bool needUpdate = updateText;
    int maxL = widget.maxLength ?? 500;
    // Truncate if necessary
    if (result.length > maxL) {
      result = result.substring(0, maxL);
      needUpdate = true;
    }

    // Update controller if needed
    if (needUpdate) {
      _controller.value = _controller.value.copyWith(
        text: result,
        selection: TextSelection.fromPosition(
          TextPosition(offset: result.length),
        ),
      );
    }

    ///end added
    return widget.onChange(result);
  }

  Future<void> onMicrophoneTap() async {
    try {
      // Show the modern recording dialog
      final recognizedText = await showRecordingDialog(
        title: 'Ghi âm câu trả lời',
        hint: 'Nhấn để bắt đầu ghi âm câu trả lời...',
        onTextRecognized: (text) {
          log('Text recognized in dialog: "$text"');
        },
      );

      // If we got text back, use it to fill the form field
      if (recognizedText != null && recognizedText.isNotEmpty) {
        // Update the form field with the recognized text
        _onChanged(recognizedText, updateText: true);
      }
    } catch (e, stackTrace) {
      log('onMicrophoneTap error: $e $stackTrace');
    }
  }
}
