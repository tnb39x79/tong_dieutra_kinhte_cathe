import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_common_model.dart';

class SelectOne extends StatefulWidget {
  final String? title;
  final Function(int) onChange;
  final List<dynamic> listValue;
  final Function()? onFinish;
  final int? value;

  const SelectOne({
    super.key,
    this.title,
    required this.onChange,
    required this.listValue,
    this.value,
    this.onFinish,
  });

  @override
  SelectOneState createState() => SelectOneState();
}

class SelectOneState extends State<SelectOne> {
  int _value = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // if (widget.title != '')
        //   RichTextQuestion(
        //     widget.title ?? '',
        //   ),
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
          SearchTypeModel item = widget.listValue[index];

          return CheckBoxCircle(
            text: item.ten ?? '',
            index: index,
            currentIndex: -1,
            showIndex: false,
            styles: styleMedium.copyWith(height: 1.0),
            isSelected: _value == item.ma ||
                widget.value == item.ma ||
                (item.selected ?? true),
            onPressed: (value) {
              int val = item.ma ?? 0;
              widget.onChange(val);
              setState(() {
                _value = val;
              });
            },
          );
        });
  }
}
