import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class CheckBoxRectangleWithListData extends StatefulWidget {
  const CheckBoxRectangleWithListData({
    Key? key,
    required this.data,
    required this.onChanged,
    required this.questionId,
  }) : super(key: key);

  final List<ChiTieuModel> data;
  final Function(List<ChiTieuModel> datas, String questionId) onChanged;
  final String questionId;

  @override
  _CheckBoxRectangleWithListDataState createState() =>
      _CheckBoxRectangleWithListDataState();
}

class _CheckBoxRectangleWithListDataState
    extends State<CheckBoxRectangleWithListData> with AutomaticKeepAliveClientMixin {
  List<ChiTieuModel> lists = [];

  @override
  void initState() {
    super.initState();
  }

  onChanging(ChiTieuModel chiTieu) {
    setState(() {
      int index = lists.indexOf(chiTieu);
      if (index != -1) {
        lists.removeAt(index);
        // lists[index] = chiTieu;
      } else {
        lists.add(chiTieu);
      }
      widget.onChanged(lists, widget.questionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppValues.padding / 4),
              child: Row(
                children: [
                  _icon(index),
                  const SizedBox(width: AppValues.padding),
                  Expanded(child: _content(index))
                ],
              ),
            ),
            onTap: () => onChanging(widget.data[index]),
          );
        });
  }

  Widget _icon(int index) {
    int currentIndex = lists.indexOf(widget.data[index]);
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: currentIndex != (-1) ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: currentIndex != (-1) ? primaryColor : greyCheckBox,
        ),
      ),
      child: Image.asset(AppIcons.icTick),
    );
  }

  Widget _content(int index) {
    String text = '${widget.data[index].tenChiTieu}';

    return Text(
      text,
      style: styleMediumBold.copyWith(color: blackText, height: 1.0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
