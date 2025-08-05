// import 'package:flutter/material.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/config/config.dart';
// import 'package:gov_statistics_investigation_economic/resource/resource.dart';

// class ViewInputStatic extends StatelessWidget {
//   const ViewInputStatic(
//       {super.key,
//       this.value,
//       this.stringValue,
//       this.titleText,
//       this.question,
//       this.dvt = '',
//       this.cap = 2,
//       this.txtStyle});
//   final num? value;
//   final QuestionCommonModel? question;
//   final String? stringValue;
//   final String? titleText;
//   final String? dvt;
//   final int? cap;
//   final TextStyle? txtStyle;
//   @override
//   Widget build(BuildContext context) {
//     String valueText =
//         value != null ? value.toString().replaceAll('.', ',') : '';
//     String text = stringValue != null ? stringValue! : valueText;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichTextQuestion(
//           _handleText(),
//           level: cap ?? cap!,
//         ),
//         const SizedBox(height: 4),
//         WidgetFieldInput(
//           controller: TextEditingController(text: text),
//           enable: false,
//           hint: 'Nhập vào đây',
//           keyboardType: TextInputType.number,
//           txtStyle: txtStyle,
//           suffix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   dvt ?? dvt!,
//                   style: cap! == 2
//                       ? styleMediumBold
//                       : TextStyle(color: Theme.of(context).hintColor),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   String _handleText() {
//     var mainName = titleText ?? '';
//     return mainName;
//   }
// }
