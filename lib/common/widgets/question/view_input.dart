import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class ViewInput extends StatelessWidget {
  const ViewInput({
    Key? key,
    this.value,
    this.stringValue,
    required this.question,
  }) : super(key: key);
  final num? value;
  final QuestionCommonModel question;
  final String? stringValue;

  @override
  Widget build(BuildContext context) {
    String valueText =
        value != null ? value.toString().replaceAll('.', ',') : '';
    String text = stringValue != null ? stringValue! : valueText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          _handleText(),
          level: question.cap ?? 2,
        ),
        const SizedBox(height: 4),
        WidgetFieldInput(
          controller: TextEditingController(text: text),
          enable: false,
          hint: 'Nhập vào đây',
          keyboardType: TextInputType.number,
          suffix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  question.dVT ?? '',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  String _handleText() {
    var mainName = question.tenCauHoi ?? '';

    // if (widget.subName != null) {
    //   if (_mainName.contains('[')) {
    //     String _string1 = _mainName.substring(0, _mainName.indexOf('['));
    //     String _string2 = widget.subName ?? '';
    //     String _string3 = _mainName.substring(_mainName.indexOf(']') + 1);
    //     return _string1 + _string2 + _string3;
    //   }
    // }

    return mainName;
  }
}
