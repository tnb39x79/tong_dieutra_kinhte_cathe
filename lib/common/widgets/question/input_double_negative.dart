// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/resource/resource.dart';

// class InputDoubleNegative extends StatefulWidget {
//   const InputDoubleNegative(
//       {required this.question,
//       required this.onChange,
//       this.validator,
//       this.type = 'int',
//       this.value,
//       this.enable = true,
//       this.subName,
//       this.product,
//       this.showDtv = false,
//       this.rightString,
//       this.flteringTextInputFormatterRegExp,
//       this.hintText,
//       super.key});

//   final QuestionCommonModel question;
//   final Function(double?) onChange;
//   final String? Function(String?)? validator;
//   final String type;
//   final double? value;
//   final bool enable;
//   final String? subName;
//   final bool showDtv;
//   final ProductModel? product;
//   final String? rightString;
//   final RegExp? flteringTextInputFormatterRegExp;
//   final String? hintText;

//   @override
//   InputDoubleNegativeState createState() => InputDoubleNegativeState();
// }

// class InputDoubleNegativeState extends State<InputDoubleNegative> {
//   // ignore: prefer_final_fields
//   TextEditingController _controller = TextEditingController();
//   @override
//   void initState() {
//     if (widget.value != null) {
//       _controller.text = (widget.type == "double")
//           ? widget.value.toString().replaceAll(',', '.')
//           : widget.value.toString();
//     }

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var wFilter = widget.flteringTextInputFormatterRegExp ??
//         RegExp(r"^[-]?\d{0,9}(\.\d{0,2})?");

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichTextQuestion(
//           widget.question.tenCauHoi ?? '',
//           level: widget.question.cap ?? 2,
//         ),
//         const SizedBox(height: 4),
//         WidgetFieldInput(
//           controller: _controller,
//           enable: widget.enable,
//           hint: widget.hintText ?? 'Nhập vào đây',
//           keyboardType: Platform.isAndroid
//               ? TextInputType.number
//               : const TextInputType.numberWithOptions(decimal: true),
//           validator: widget.validator,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(wFilter),
//             // ThousandsFormatter(),
//           ],
//           onChanged: (value) {
//             // cover string to double
//             if (value == '') {
//               widget.onChange(null);
//             } else {
//               String result = value;

//               if (result.length > 14) {
//                 result = result.substring(0, 14);
//                 _controller.text = result;
//                 _controller.selection = TextSelection.fromPosition(
//                     TextPosition(offset: result.length));
//               }

//               var v = result.replaceAll(',', '.');
//               var re = double.tryParse(v);
//               widget.onChange(re);
//             }
//           },
//           suffix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   _handleDVT(),
//                   style: TextStyle(color: Theme.of(context).hintColor),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   String _handleDVT() {
//     // if (widget.showDtv && widget.product != null) {
//     //   return widget.product!.donViTinh ?? "";
//     // }
//     if (widget.showDtv && widget.rightString != null) {
//       return widget.rightString ?? "";
//     }

//     return widget.question.dVT ?? '';
//   }

//   String _handleText() {
//     var mainName = widget.question.tenCauHoi ?? '';

//     if (widget.subName != null) {
//       if (mainName.contains('[')) {
//         String string1 = mainName.substring(0, mainName.indexOf('['));
//         String string2 = widget.subName ?? '';
//         String string3 = mainName.substring(mainName.indexOf(']') + 1);
//         return string1 + string2 + string3;
//       }
//     }

//     return mainName;
//   }
// }
