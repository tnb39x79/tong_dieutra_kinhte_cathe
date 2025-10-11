import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class CheckBoxCircleDm extends StatelessWidget {
  const CheckBoxCircleDm(
      {super.key,
      required this.text,
      required this.index,
      required this.currentIndex,
      required this.onPressed,
      this.showIndex = true,
      this.styles,
      this.isSelected = false,
      this.loaiGhiRo,
      this.enable=true});

  final String text;
  final int index;
  final int currentIndex;
  final Function(int) onPressed;
  final bool showIndex;
  final bool isSelected;
  final TextStyle? styles;
  final int? loaiGhiRo;
  final bool? enable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => (enable != null && enable == true) ? onPressed(index) : {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.padding / 2),
        child: Row(
          children: [
            _icon(),
            const SizedBox(width: AppValues.padding),
            Expanded(child: _content())
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isSelected || currentIndex == index
            ? (enable != null && enable == true)
                ? primaryColor
                : Colors.grey
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: isSelected || currentIndex == index
              ? (enable != null && enable == true)
                  ? primaryColor
                  : Colors.grey
              : greyCheckBox,
        ),
      ),
      child: Image.asset(AppIcons.icTick),
    );
  }

  Widget _content() {
    String _text = showIndex ? '${index + 1}.$text' : text;

    return Text(
      _text,
      style: styles ??
          styleMediumBold.copyWith(
              color:
                  (enable != null && enable == true) ? blackText : Colors.grey,
              height: 1.0),
    );
  }
}
