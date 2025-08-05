

import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class SelectString extends StatefulWidget {
  final QuestionCommonModel question;
  final Function(String?) onChange;
  final List<ChiTieuModel> listValue;
  final Function()? onFinish;
  final String? value;

  const SelectString({
    Key? key,
    required this.question,
    required this.onChange,
    required this.listValue,
    this.onFinish,
    this.value,
  }) : super(key: key);

  @override
  _SelectStringState createState() => _SelectStringState();
}

class _SelectStringState extends State<SelectString> {
  String _value = '';
  int selected = -1;

  @override
  void initState() {
    if (widget.value != null) {
      _value = widget.value ?? '';
      selected = widget.listValue
          .indexWhere((element) => element.maChiTieu == widget.value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextQuestion(widget.question.tenCauHoi ?? ''),
        _buildValues(),
      ],
    );
  }

  Widget _buildValues() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listValue.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          ChiTieuModel item = widget.listValue[index];
          var name = widget.listValue[index].tenChiTieu!.split('>>');

          return CheckBoxRectangle(
            text: name[0],
            index: index,
            currentIndex: selected,
            showIndex: false,
            onPressed: (value) {
              if (item.maChiTieu == '0' && widget.onFinish != null) {
                widget.onFinish!();
              } else {
                setState(() {
                  _value = item.maChiTieu ?? '';
                  selected = index;
                  widget.onChange(_value);
                });
              }
            },
          );
        });
  }
}
