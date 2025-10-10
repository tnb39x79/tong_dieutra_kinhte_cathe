import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/currency_input_formatter.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/formatter_extension_methods.dart';
import 'package:gov_statistics_investigation_economic/common/money_formatters/formatters/money_input_enums.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class InputInt extends StatefulWidget {
  const InputInt(
      {required this.question,
      required this.onChange,
      this.validator,
      this.type = 'int',
      this.value,
      this.enable = true,
      this.subName,
      this.product,
      this.showDtv = false,
      this.rightString,
      this.flteringTextInputFormatterRegExp,
      this.hintText,
      this.subText,
      this.txtStyle,
      this.warningText,
      this.hideQuestionCaption = false,
      this.decimalDigits,
      super.key});

  final QuestionCommonModel question;
  final Function(num?) onChange;
  final String? Function(String?)? validator;
  final String type;
  final num? value;
  final bool enable;
  final String? subName;
  final bool showDtv;
  final ProductModel? product;
  final String? rightString;
  final RegExp? flteringTextInputFormatterRegExp;
  final String? hintText;
  final String? subText;
  final TextStyle? txtStyle;
  final String? warningText;
  final bool? hideQuestionCaption;
  final int? decimalDigits;
  @override
  InputIntState createState() => InputIntState();
}

class InputIntState extends State<InputInt> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    if (widget.value != null) {
      if (widget.type == 'double') {
        _controller.text = widget.value
            .toString()
            .replaceAll(',', '.')
            .toCurrencyString(
                thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                mantissaLength: widget.decimalDigits ?? 2);
      } else if (widget.type == 'int') {
        _controller.text = widget.value
            .toString()
            .replaceAll(',', '.')
            .toCurrencyString(
                thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                mantissaLength: 0);
      } else {
        _controller.text = widget.value.toString().replaceAll(',', '.');
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var wFilter = widget.flteringTextInputFormatterRegExp ??
        RegExp('[+-]?([0-9]+([.,][0-9]*)?|[.,][0-9]+)');
    var wRegExp = widget.type == 'int' ? RegExp('[0-9]') : wFilter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hideQuestionCaption == false)
          RichTextQuestion(
            widget.question.tenCauHoi ?? '',
            level: widget.question.cap ?? 2,
            subText: widget.subText,
            moTaSanPham: widget.subName,
          ),
        const SizedBox(height: 4),
        WidgetFieldInput(
          controller: _controller,
          enable: widget.enable,
          txtStyle: widget.txtStyle,
          hint: widget.hintText ?? 'Nhập vào đây',
          keyboardType: Platform.isAndroid
              ? TextInputType.number
              : const TextInputType.numberWithOptions(decimal: true),
          validator: widget.validator,
          inputFormatters: [
            // FilteringTextInputFormatter.allow(wFilter),
            widget.type == 'int'
                ? CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                    mantissaLength: 0)
                : CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.spaceAndPeriodMantissa,
                    mantissaLength: widget.decimalDigits ?? 2)
          ],
          onChanged: (value) {
            // cover string to double
            if (value == '') {
              widget.onChange(null);
            } else {
              if (widget.type == 'int') {
                ///added by tuannb 18/09/2024: Giới hạn độ dài kiểu int32=9 chữ số
                String result = value.replaceAll(' ', '');
                if (result.length > 8) {
                  result = result.substring(0, 8);
                  _controller.text = result;
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: result.length));
                }

                ///end added

                var myDouble =
                    int.parse(result.replaceAll(' ', '').replaceAll(',', ''));
                widget.onChange(myDouble);
              } else {
                ///added by tuannb 18/09/2024: Giới hạn độ dài kiểu dboule= decimal(18,2) ở sql = 18 chữ số bao gồm dấu chấm thập phân và số lẻ
                String result = value;

                if (result.length > 16) {
                  result = result.substring(0, 16);
                  _controller.text = result;
                  _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: result.length));
                }

                ///end added
                var v = double.parse(
                    result.replaceAll(' ', '').replaceAll(',', '.'));
                widget.onChange(v);
              }
            }
          },
          suffix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _handleDVT(),
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ),
        wWarningText(),
        const SizedBox(height: 12),
      ],
    );
  }

  String _handleDVT() {
    // if (widget.showDtv && widget.product != null) {
    //   return widget.product!.donViTinh ?? "";
    // }
    if (widget.showDtv && widget.rightString != null) {
      return widget.rightString ?? "";
    }

    return widget.question.dVT ?? '';
  }

  Widget wWarningText() {
    if (widget.warningText != null && widget.warningText != '') {
      return Text(
        widget.warningText!,
        style: const TextStyle(color: Colors.orange),
      );
    }
    return const SizedBox();
  }
}
