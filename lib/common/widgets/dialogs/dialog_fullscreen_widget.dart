import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import '../../common.dart';

class DialogFullScreenWidget extends StatelessWidget {
  const DialogFullScreenWidget({
    super.key,
    required this.onPressedPositive,
    required this.onPressedNegative,
    required this.title,
    required this.content,
    this.body,
    this.confirmText,
    this.isCancelButton = true,
  });
  final Function() onPressedPositive;
  final Function() onPressedNegative;

  final String title;
  final String content;
  final String? confirmText;
  final Widget? body;
  final bool isCancelButton;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(  
      backgroundColor: Colors.white,
      child: Container(        
        width: Get.width,
        padding: const EdgeInsets.all(16.0),
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
            style: styleLargeBold.copyWith(color: warningColor),
          ),
          const SizedBox(height: 4),
          Container(
            child: body,
          ),
          const SizedBox(height: 16),
          _buttonActions(),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Text(
          title,
          style: styleLargeBold.copyWith(color: warningColor),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: styleSmallBold.copyWith(color: greyColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
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
