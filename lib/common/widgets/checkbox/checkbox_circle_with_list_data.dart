import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class CheckBoxCircleWithListData extends StatefulWidget {
  const CheckBoxCircleWithListData({
    Key? key,
    required this.data,
    required this.onChanged,
    required this.questionId,
  }) : super(key: key);

  final String questionId;
  final List<ChiTieuModel> data;
  final Function(ChiTieuModel data, String questionId) onChanged;
  
  @override
  _CheckBoxCircleWithListDataState createState() =>
      _CheckBoxCircleWithListDataState();
}

class _CheckBoxCircleWithListDataState
    extends State<CheckBoxCircleWithListData> with AutomaticKeepAliveClientMixin {

  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  onChanging(int id){
    setState(() {
      currentIndex = id;
      widget.onChanged(widget.data[currentIndex], widget.questionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.data.length,
      itemBuilder: (context, index){
      return InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppValues.padding/4),
          child: Row(
            children: [
              _icon(index),
              const SizedBox(width: AppValues.padding),
              Expanded(child: _content(index))
            ],
          ),
        ),
        onTap: () => onChanging(index),
      );
    });
  }

  Widget _icon(int index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: currentIndex == index ? primaryColor : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: currentIndex == index ? primaryColor : greyCheckBox,
        ),
      ),
      child: Image.asset(AppIcons.icTick),
    );
  }

  Widget _content(int index) {
    String _text = '${widget.data[index].tenChiTieu}';

    return Text(
      _text,
      style: styleMediumBold.copyWith(color: blackText, height: 1.0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
