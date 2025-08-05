// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/common/widgets/input/widget_field_input_warning.dart';
// import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
// import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
// import 'package:gov_statistics_investigation_economic/resource/resource.dart';

// class InputIntChiTieuWarning extends StatefulWidget {
//   const InputIntChiTieuWarning(
//       {required this.chiTieuCot,
//       required this.onChange,
//       this.validator,
//       this.chiTieuDong,
//       this.type = 'int',
//       this.value,
//       this.enable = true,
//       this.subName,
//       this.product,
//       this.showDtv = false,
//       this.showDvtTheoChiTieuDong = false,
//       this.rightString,
//       this.flteringTextInputFormatterRegExp,
//       this.txtStyle,
//       this.bgColor,
//       this.hintText,
//       this.warningText,
//       this.warning,
//       super.key});

//   final dynamic chiTieuCot;
//   final Function(num?) onChange;
//   final String? Function(String?)? validator;
//   final dynamic? chiTieuDong;
//   final String type;
//   final num? value;
//   final bool enable;
//   final String? subName;
//   final bool showDtv;
//   final bool showDvtTheoChiTieuDong;
//   final ProductModel? product;
//   final String? rightString;
//   final RegExp? flteringTextInputFormatterRegExp;
//   final TextStyle? txtStyle;
//   final Color? bgColor;
//   final String? hintText;
//   final String? warningText;
//   final String? Function(String?)? warning;

//   @override
//   InputIntChiTieuWarningState createState() => InputIntChiTieuWarningState();
// }

// class InputIntChiTieuWarningState extends State<InputIntChiTieuWarning> {
//   // ignore: prefer_final_fields
//   TextEditingController _controller = TextEditingController();
//   bool isWarning = false;

//   @override
//   void initState() {
//     if (widget.value != null) {
//       _controller.text = widget.value.toString().replaceAll(',', '.');
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
//         RegExp('[+-]?([0-9]+([.,][0-9]*)?|[.,][0-9]+)');
//     var wRegExp = widget.type == 'int' ? RegExp('[0-9]') : wFilter;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         wTextQuesion(),
//         const SizedBox(height: 4),
//         WidgetFieldInputWarning(
//           controller: _controller,
//           enable: widget.enable,
//           txtStyle: widget.txtStyle,
//           bgColor: widget.bgColor,
//           hint: widget.enable
//               ? (widget.hintText ?? 'Nhập vào đây')
//               : (widget.type == "int" ? '0' : ''),
//           keyboardType: Platform.isAndroid
//               ? TextInputType.number
//               : const TextInputType.numberWithOptions(decimal: true),
//           validator: (value) {
//             if (widget.validator != null) {
//               var validRes = widget.validator!(value);
//               if (validRes != null && validRes != '') {
//                 if (validRes.contains(AppDefine.waringText)) {
//                   WidgetsBinding.instance
//                       .addPostFrameCallback((_) => setState(() {
//                             isWarning = true;
//                           }));
//                 }
//                 else{
//                    WidgetsBinding.instance
//                       .addPostFrameCallback((_) => setState(() {
//                             isWarning = false;
//                           }));
//                 }
//               }
//               return validRes;
//             }
//           },
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(wRegExp),
//             // ThousandsFormatter(),
//           ],
//           onChanged: (value) {
//             // cover string to double
//             if (value == '') {
//               widget.onChange(null);
//             } else {
//               if (widget.type == 'int') {
//                 ///added by tuannb 18/09/2024: Giới hạn độ dài kiểu int32=9 chữ số
//                 String result = value;
//                 if (result.length > 8) {
//                   result = result.substring(0, 8);
//                   _controller.text = result;
//                   _controller.selection = TextSelection.fromPosition(
//                       TextPosition(offset: result.length));
//                 }

//                 ///end added

//                 var myDouble = int.parse(result.replaceAll(',', ''));
//                 widget.onChange(myDouble);
//               } else {
//                 ///added by tuannb 18/09/2024: Giới hạn độ dài kiểu dboule= decimal(18,2) ở sql = 18 chữ số bao gồm dấu chấm thập phân và số lẻ
//                 String result = value;

//                 if (result.length > 14) {
//                   result = result.substring(0, 14);
//                   _controller.text = result;
//                   _controller.selection = TextSelection.fromPosition(
//                       TextPosition(offset: result.length));
//                 }

//                 ///end added
//                 var v = double.parse(result.replaceAll(',', '.'));
//                 widget.onChange(v);
//               }
//             }
//           },
//           suffix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 wTextDvt(),
//               ],
//             ),
//           ),
//           errorStyle: isWarning? const TextStyle(color: warningColor):const TextStyle(color: errorColor),
//           isWarning: isWarning,
//         ),
//         wWarningText(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget wTextQuesion() {
//     if (widget.chiTieuCot is ChiTieuModel) {
//       ChiTieuModel wChiTieu = widget.chiTieuCot as ChiTieuModel;
//       return RichTextQuestionChiTieu(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else if (widget.chiTieuCot is ChiTieuDongModel) {
//       ChiTieuDongModel wChiTieu = widget.chiTieuCot as ChiTieuDongModel;
//       return RichTextQuestionChiTieu(
//         wChiTieu.tenSanPham ?? '',
//         prefixText: wChiTieu.maIO,
//         level: 3,
//       );
//     } else if (widget.chiTieuCot is ChiTieuIntModel) {
//       ChiTieuIntModel wChiTieu = widget.chiTieuCot as ChiTieuIntModel;
//       return RichTextQuestionChiTieu(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   Widget wTextDvt() {
//     if (widget.showDtv && widget.rightString != null) {
//       return Text(
//         widget.rightString ?? "",
//         style: TextStyle(color: Theme.of(context).hintColor),
//       );
//     }
//     if (widget.showDvtTheoChiTieuDong) {
//       if (widget.chiTieuDong != null) {
//         if (widget.chiTieuDong is ChiTieuDongModel) {
//           ChiTieuDongModel wChiTieu = widget.chiTieuDong as ChiTieuDongModel;
//           return Text(
//             wChiTieu.dVT ?? '',
//             style: TextStyle(color: Theme.of(context).hintColor),
//           );
//         } else {
//           return const SizedBox();
//         }
//       } else {
//         return const SizedBox();
//       }
//     } else {
//       if (widget.chiTieuCot is ChiTieuModel) {
//         ChiTieuModel wChiTieu = widget.chiTieuCot as ChiTieuModel;
//         return Text(
//           wChiTieu.dVT ?? '',
//           style: TextStyle(color: Theme.of(context).hintColor),
//         );
//       } else if (widget.chiTieuCot is ChiTieuDongModel) {
//         ChiTieuDongModel wChiTieu = widget.chiTieuCot as ChiTieuDongModel;
//         return Text(
//           wChiTieu.dVT ?? '',
//           style: TextStyle(color: Theme.of(context).hintColor),
//         );
//       } else {
//         return const SizedBox();
//       }
//     }
//   }

//   Widget wWarningText() {
//     if (widget.warningText != null && widget.warningText != '') {
//       return Text(
//         widget.warningText!,
//         style: const TextStyle(color: Colors.orange),
//       );
//     }
//     return const SizedBox();
//   }

//   // Widget wWarning() {
//   //   if (widget.warning != null) {
//   //     var res = widget.warning!.call(widget.value.toString());
//   //     if (res != null && res != '') {

//   //       return Text(
//   //         res!,
//   //         style: const TextStyle(color: Colors.orange),
//   //       );
//   //     }else{
//   //        return const SizedBox();
//   //     }
//   //   }
//   //   return const SizedBox();
//   // }
// }
