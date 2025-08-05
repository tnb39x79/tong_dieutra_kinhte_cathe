import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';

class InputCustom extends StatelessWidget {
  const InputCustom({
    Key? key,
    required this.controller,
    required this.hint,
    this.validate,
    this.label,
    this.prefix,
    this.suffix,
    this.bgColor,
    this.isHideContent,
    this.enable,
    this.keyboardType,
    required this.onChanged,
    required this.keyQuestion,
  }) : super(key: key);

  final TextEditingController controller;
  final String? Function(String? value, String questionKey)? validate;
  final String hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final Color? bgColor;
  final bool? isHideContent;
  final bool? enable;
  final TextInputType? keyboardType;
  final Function(String questionKey, String value) onChanged;
  final String keyQuestion;

  @override
  Widget build(BuildContext context) {
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: controller,
              style: styleSmall,
              obscureText: isHideContent ?? false,
              enabled: enable ?? true,
              validator: (value) {
                return validate != null ? validate!(value, keyQuestion) : '';
              },
              decoration: InputDecoration(
                prefixIcon: prefix,
                suffixIcon: suffix,
                hintText: hint,
                fillColor: bgColor ?? backgroundColor,
                contentPadding:
                    const EdgeInsets.only(top: 4, left: 16, right: 16),
                hintStyle: styleSmall.copyWith(color: greyColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: greyBorder,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: greyBorder,
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
              onChanged: (String value) => onChanged(keyQuestion, value),
            ),
          ),
        ),
      ],
    );
  }
}
