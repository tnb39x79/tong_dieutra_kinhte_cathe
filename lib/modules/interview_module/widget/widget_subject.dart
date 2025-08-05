import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class WidgetSubject extends StatelessWidget {
  const WidgetSubject({
    Key? key,
    required this.index,
    required this.onPressed,
    required this.name,
    this.address,
    required this.questions,
  }) : super(key: key);

  final Function() onPressed;
  final String index;
  final String name;
  final String? address;
  final String questions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding,
          0,
          AppValues.padding,
          AppValues.padding,
        ),
        padding: const EdgeInsets.all(AppValues.padding),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
            _iconActions(),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _titleTop(),
        _titleCenter(),
        _titleBottom(),
      ],
    );
  }

  Widget _iconActions() {
    return const Icon(Icons.arrow_forward_ios_rounded, color: greyBorder);
  }

  Widget _titleTop() {
    return RichText(
      text: TextSpan(
        text: index.length == 1 ? '0$index' : index,
        style: styleMediumBold.copyWith(color: greyCheckBox),
        children: <TextSpan>[
          TextSpan(
            text: '  $name',
            style: styleMediumBold.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _titleBottom() {
    return Text(
     questions.contains('Phiếu') ? questions:'Phiếu $questions',
      style: styleMedium500.copyWith(color: warningColor),
    );
  }

  Widget _titleCenter() {
    return address != null
        ? Padding(
            padding: const EdgeInsets.only(left: AppValues.padding),
            child: Text(
              address!,
              style: styleMedium,
            ),
          )
        : const SizedBox();
  }
}
