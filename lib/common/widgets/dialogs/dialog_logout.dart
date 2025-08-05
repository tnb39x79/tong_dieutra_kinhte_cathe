import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/button/button.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

class DialogLogOut extends StatelessWidget {
  const DialogLogOut({
    Key? key,
    required this.onPressedPositive,
    required this.onPressedNegative,
  }) : super(key: key);
  final Function() onPressedPositive;
  final Function() onPressedNegative;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'logout'.tr,
              style: styleLargeBold.copyWith(color: warningColor),
            ),
            const SizedBox(height: 8),
            Text(
              'logout_content'.tr,
              style: styleSmallBold.copyWith(color: greyColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buttonActions(),
          ],
        ),
      ),
    );
  }

  Widget _buttonActions() {
    return Row(
      children: [
        Expanded(
          child: WidgetButtonBorder(
              title: 'cancel'.tr, onPressed: onPressedNegative),
        ),
        const SizedBox(width: AppValues.padding),
        Expanded(
          child: WidgetButton(title: 'logout'.tr, onPressed: onPressedPositive),
        ),
      ],
    );
  }
}
