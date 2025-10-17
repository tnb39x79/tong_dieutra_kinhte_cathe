import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

import '../../common.dart';

class DialogBarrierWidget extends StatelessWidget {
  const DialogBarrierWidget(
      {super.key,
      required this.onPressedPositive,
      required this.onPressedNegative,
      required this.title,
      required this.content,
      this.body,
      this.confirmText,
      this.content2,
      this.isCancelButton = true,
      this.color,
      this.content2Color,
      this.content2StyleText,
      this.btnAcceptColor,
      this.btnCancelColor,
      this.isHighlight,
      this.subItem});

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
  final String? content2;
  final Color? content2Color;
  final TextStyle? content2StyleText;
  final Color? btnAcceptColor;
  final bool? isHighlight;
  final String? subItem;
final Color? btnCancelColor;
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
            style: styleLargeBold.copyWith(color: color ?? primaryColor),
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
          style: styleLargeBold.copyWith(
              color: color ?? primaryColor, fontSize: 18),
        ),
        const SizedBox(height: 8),
        wContent(),
        wTextConfirm(),
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
            title: confirmText ?? "agree".tr, onPressed: onPressedPositive,
            background: btnCancelColor,
            overlayColor:  btnCancelColor != null
                ? btnCancelColor!.withValues(alpha: 0.5)
                : btnCancelColor),
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
            title: confirmText ?? "agree".tr,
            onPressed: onPressedPositive,
            background: btnAcceptColor,
            overlayColor: btnAcceptColor != null
                ? btnAcceptColor!.withValues(alpha: 0.3)
                : btnAcceptColor,
          ),
        ),
      ],
    );
  }

  Widget wContent() {
    if (isHighlight != null && isHighlight == true) {
      String textTmp = content;
      var hasSubText = content.toLowerCase().contains('[');
      if (hasSubText) {
        textTmp = textTmp.replaceAll('[', '#').replaceAll(']', '#');
        var arr = textTmp.split('#');
        String firstPart = '${arr[0]}[';
        String secondPart = arr[1];
        String thirdPart = '] ${arr[2]}';
        if (subItem != null && subItem != '') {
          secondPart = subItem ?? '';
        }
        return RichText(
            text: TextSpan(
                style: const TextStyle(
                    fontSize: fontMedium,
                    height: textHeight,
                    fontFamily: inter,
                    //    fontWeight: FontWeight.w700,
                    color: Colors.black),
                children: [
              TextSpan(
                  text: firstPart,
                  style: const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      // fontWeight: FontWeight.w700,
                      color: Colors.black)),
              TextSpan(
                  text: secondPart,
                  style: const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      fontWeight: FontWeight.w700,
                      color: primaryColor)),
              TextSpan(
                  text: thirdPart,
                  style: const TextStyle(
                      fontSize: fontMedium,
                      height: textHeight,
                      fontFamily: inter,
                      //  fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ]));
      }
      return Text(
        content,
        style: styleMediumW400.copyWith(color: blackText),
        textAlign: TextAlign.center,
      );
    }
    return Text(
      content,
      style: styleMediumW400.copyWith(color: blackText),
      textAlign: TextAlign.center,
    );
  }

//    Text(
//           content,
//           style: styleMediumW400.copyWith(color: blackText),
//           textAlign: TextAlign.center,
//         );
// }
  Widget wTextConfirm() {
    if (content2 != null && content2 != '' && isHighlight == null) {
      return Text(
        content2!,
        style: content2StyleText ??
            styleMediumW400.copyWith(color: content2Color ?? blackText),
        textAlign: TextAlign.center,
      );
    }
    return const SizedBox();
  }
}
