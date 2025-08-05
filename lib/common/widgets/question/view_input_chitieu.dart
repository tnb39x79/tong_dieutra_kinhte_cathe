// import 'package:flutter/material.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/resource/resource.dart';

// class ViewInputChiTieu extends StatelessWidget {
//   const ViewInputChiTieu({
//     super.key,
//     this.value,
//     this.stringValue,
//     required this.chiTieu,
//   });
//   final num? value;
//   final dynamic chiTieu;
//   final String? stringValue;

//   @override
//   Widget build(BuildContext context) {
//     String valueText =
//         value != null ? value.toString().replaceAll('.', ',') : '';
//     String text = stringValue != null ? stringValue! : valueText;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         wTextQuesion(),
//         const SizedBox(height: 4),
//         WidgetFieldInput(
//           controller: TextEditingController(text: text),
//           enable: false,
//           hint: 'Nhập vào đây',
//           keyboardType: TextInputType.number,
//           suffix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   textDvt(),
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

//   Widget wTextQuesion() {
//     if (chiTieu is ChiTieuModel) {
//       ChiTieuModel wChiTieu = chiTieu as ChiTieuModel;
//       return RichTextQuestion(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else if (chiTieu is ChiTieuDongModel) {
//       ChiTieuDongModel wChiTieu = chiTieu as ChiTieuDongModel;
//       return RichTextQuestion(
//         wChiTieu.tenSanPham ?? '',
//         level: 3,
//       );
//     } else if (chiTieu is ChiTieuIntModel) {
//       ChiTieuIntModel wChiTieu = chiTieu as ChiTieuIntModel;
//       return RichTextQuestion(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   String textDvt() {
//     if (chiTieu is ChiTieuModel) {
//       ChiTieuModel wChiTieu = chiTieu as ChiTieuModel;
//       return wChiTieu.dVT ?? '';
//     } else if (chiTieu is ChiTieuDongModel) {
//       ChiTieuDongModel wChiTieu = chiTieu as ChiTieuDongModel;
//       return wChiTieu.dVT ?? '';
//     } else {
//       return "";
//     }
//   }
// }
