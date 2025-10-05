import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/config/config.dart';

class WidgetFieldInputMix extends StatelessWidget {
  const WidgetFieldInputMix({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.label,
    this.prefix,
    this.suffix,
    this.bgColor,
    this.isHideContent,
    this.enable = true,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.minLines = 1,
    this.onFieldSubmitted,
    this.padding = const EdgeInsets.only(top: 4, left: 16, right: 16),
    this.onMicrophoneTap,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final Color? bgColor;
  final bool? isHideContent;
  final bool enable;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? minLines;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets padding;
  final Function()? onMicrophoneTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Text(label!, style: styleSmall) : const SizedBox(),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  controller: controller,
                  style: styleSmall,
                  obscureText: isHideContent ?? false,
                  enabled: enable,
                  validator: validator,
                  maxLength: maxLength,
                  minLines: minLines,
                  onFieldSubmitted: (value) => onFieldSubmitted?.call(value),
                  maxLines: minLines,
                  decoration: InputDecoration(
                    prefixIcon: prefix,
                    suffixIcon: suffix,
                    hintText: hint,
                    fillColor: bgColor ??
                        (enable != true
                            ? backgroundDisableColor
                            : backgroundColor),
                    filled: true,
                    contentPadding: padding,
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
                    errorMaxLines: 3,
                  ),
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  inputFormatters: inputFormatters,
                ),
              ),
            ),
            if (onMicrophoneTap != null)
              IconButton(
                onPressed: enable == true ? onMicrophoneTap : null,
                // onPressed: onMicrophoneTap,
                icon: const Icon(Icons.mic),
              )
          ],
        ),
      ],
    );
  }
}
