import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import '../../common.dart';

class DialogBarrierWidget extends StatelessWidget {
  const DialogBarrierWidget({
    super.key,
    required this.onPressedPositive,
    required this.onPressedNegative,
    required this.title,
    required this.content,
    this.body,
    this.confirmText,
    this.isCancelButton = true,
    this.color,
  });

  ///Agree Acrtion
  final Function() onPressedPositive;

  ///Cancel Action
  final Function() onPressedNegative;

  final String title;
  final String content;
  final String? confirmText;
  final Widget? body;
  final bool isCancelButton;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.padding),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppValues.padding),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(24.0),
        child: _body(),
      ),
    );
  }

  _body() {
    if (body != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: styleLargeBold.copyWith(color:color?? warningColor),
          ),
          const SizedBox(height: 8),
          Container(
            child: body,
          ),
          const SizedBox(height: 24),
          _buttonActions(),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: styleLargeBold.copyWith(color: color?? warningColor),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: styleMediumW400.copyWith(color: blackText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buttonActions(),
      ],
    );
  }

  Widget _buttonActions() {
    if (!isCancelButton) {
      return Container(
        width: Get.width * 0.3,
        constraints: const BoxConstraints(maxWidth: 200),
        child: WidgetButton(
            title: confirmText ?? "agree".tr, onPressed: onPressedPositive),
      );
    }
    return Row(
      children: [
        Expanded(
          child: WidgetButtonBorder(
              title: 'cancel'.tr, onPressed: onPressedNegative),
        ),
        const SizedBox(width: AppValues.padding),
        Expanded(
          child: WidgetButton(
              title: confirmText ?? "agree".tr, onPressed: onPressedPositive),
        ),
      ],
    );
  }
}
