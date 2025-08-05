import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:intl/intl.dart';

class WidgetFieldInput extends StatelessWidget {
  const WidgetFieldInput(
      {super.key,
      required this.controller,
      required this.hint,
      this.validator,
      this.label,
      this.prefix,
      this.suffix,
      this.bgColor,
      this.isHideContent,
      this.enable,
      this.keyboardType,
      this.onChanged,
      this.inputFormatters,
      this.maxLength,
      this.maxLine = 1,
      this.txtStyle});

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final Color? bgColor;
  final TextStyle? txtStyle;
  final bool? isHideContent;
  final bool? enable;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    var styleCustomize = (enable != null && enable != true)
        ? styleSmall.copyWith(color: disabledblackText)
        : styleSmall;
    // final NumberFormat numFormat = NumberFormat('###,##0.00', 'en_US');
    // final NumberFormat numSanitizedFormat = NumberFormat('en_US');
    if (txtStyle != null) {
      styleCustomize = txtStyle!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Text(label!, style: styleSmall) : const SizedBox(),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.borderLv1),
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              maxLength: maxLength,
              //  maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: controller,
              style: styleCustomize,
              obscureText: isHideContent ?? false,
              enabled: enable ?? true,
              validator: validator,
              maxLines: maxLine,
              minLines: 1,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: prefix,
                suffixIcon: suffix,
                hintText: hint,
                errorMaxLines: 3,
                fillColor: bgColor ??
                    (enable != null && enable != true
                        ? backgroundDisableColor
                        : backgroundWhiteColor),
                filled: true,
                contentPadding:
                    const EdgeInsets.only(top: 4, left: 16, right: 16),
                hintStyle: styleSmall.copyWith(color: greyColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: BorderSide(
                    color: (enable != null && enable != true)
                        ? greyBorder
                        : primaryLightColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: BorderSide(
                    color: (enable != null && enable != true)
                        ? greyBorder
                        : primaryColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: greyBorder,
                    width: 1.0,
                  ),
                ), 
              ),
              keyboardType: keyboardType,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
              // onTap: () {
              //   var textFieldNum = controller.value.text;
              //   if(textFieldNum!=''){ 
              //   var numSanitized = numSanitizedFormat.parse(textFieldNum);
              //   controller.value = TextEditingValue(
              //     /// Clear if TextFormField value is 0
              //     text: numSanitized == 0 ? '' : '$numSanitized',
              //     selection:
              //         TextSelection.collapsed(offset: '$numSanitized'.length),
              //   );
              //   }
              // },
              // onFieldSubmitted: (valueInput) {
              //   /// Set value to 0 if TextFormField value is empty
              //   if (valueInput == '') { 
              //   final formattedPrice =
              //       numFormat.format(double.parse(valueInput));
              //   debugPrint('Formatted $formattedPrice');
              //   controller.value = TextEditingValue(
              //     text: formattedPrice,
              //     selection:
              //         TextSelection.collapsed(offset: formattedPrice.length),
              //   );
              //   }
              // },
            ),
          ),
        ),
      ],
    );
  }
}
