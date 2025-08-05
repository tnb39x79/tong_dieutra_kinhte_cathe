import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:get/get.dart';

class CheckBoxCircleYNQuestion extends StatefulWidget {
  const CheckBoxCircleYNQuestion({
    Key? key,
    required this.questionKey,
    required this.onChanged,
  }) : super(key: key);

  final String questionKey;
  final Function(String, bool) onChanged;
  @override
  _CheckBoxCircleYNQuestionState createState() =>
      _CheckBoxCircleYNQuestionState();
}

class _CheckBoxCircleYNQuestionState extends State<CheckBoxCircleYNQuestion> {
  bool value = true;

  @override
  void initState() {
    super.initState();
  }

  onChangeValue(bool value) {
    setState(() {
      this.value = value;
      widget.onChanged(widget.questionKey, this.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: AppValues.padding / 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: value ? primaryColor : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: value ? primaryColor : greyCheckBox,
                    ),
                  ),
                  child: Image.asset(AppIcons.icTick),
                ),
                const SizedBox(width: AppValues.padding),
                Expanded(child: Text('yes'.tr))
              ],
            ),
          ),
          onTap: () => onChangeValue(true),
        ),
        InkWell(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: AppValues.padding / 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: !value ? primaryColor : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: !value ? primaryColor : greyCheckBox,
                    ),
                  ),
                  child: Image.asset(AppIcons.icTick),
                ),
                const SizedBox(width: AppValues.padding),
                Expanded(child: Text('no'.tr))
              ],
            ),
          ),
          onTap: () => onChangeValue(false),
        ),
      ],
    );
  }
}
