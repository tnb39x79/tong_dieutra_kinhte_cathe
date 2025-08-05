// import 'package:flutter/material.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/resource/model/model.dart';

// class InputStringChiTieu extends StatefulWidget {
//   const InputStringChiTieu(
//       {required this.chiTieu,
//       required this.onChange,
//       this.validator,
//       this.value,
//       this.enable = true,
//       this.subName,
//       this.maxLine = 1,
//       super.key});

//   final dynamic chiTieu;
//   final Function(String?)? onChange;
//   final String? Function(String?)? validator;
//   final String? value;
//   final bool enable;
//   final String? subName;
//   final int maxLine;
//   @override
//   InputStringState createState() => InputStringState();
// }

// class InputStringState extends State<InputStringChiTieu> {
//   // ignore: prefer_final_fields
//   TextEditingController _controller = TextEditingController();
//   @override
//   void initState() {
//     if (widget.value != null) {
//       _controller.text = widget.value.toString();
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
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         wTextQuesion(),
//         const SizedBox(height: 4),
//         WidgetFieldInput(
//           controller: _controller,
//           enable: widget.enable,
//           hint: 'Nhập vào đây',
//           validator: widget.validator,
//           onChanged: (String? value) =>
//               widget.onChange!(value != "" ? value : null),
//           maxLine: widget.maxLine,
//           suffix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 wTextDvt(),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget wTextQuesion() {
//     if (widget.chiTieu is ChiTieuModel) {
//       ChiTieuModel wChiTieu = widget.chiTieu as ChiTieuModel;
//       return RichTextQuestion(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else if (widget.chiTieu is ChiTieuDongModel) {
//       ChiTieuDongModel wChiTieu = widget.chiTieu as ChiTieuDongModel;
//       return RichTextQuestion(
//         wChiTieu.tenSanPham ?? '',
//         level: 3,
//       );
//     } else if (widget.chiTieu is ChiTieuIntModel) {
//       ChiTieuIntModel wChiTieu = widget.chiTieu as ChiTieuIntModel;
//       return RichTextQuestion(
//         wChiTieu.tenChiTieu ?? '',
//         level: 3,
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   Widget wTextDvt() {
//     if (widget.chiTieu is ChiTieuModel) {
//       ChiTieuModel wChiTieu = widget.chiTieu as ChiTieuModel;
//       return Text(
//         wChiTieu.dVT ?? '',
//         style: TextStyle(color: Theme.of(context).hintColor),
//       );
//     } else if (widget.chiTieu is ChiTieuDongModel) {
//       ChiTieuDongModel wChiTieu = widget.chiTieu as ChiTieuDongModel;
//       return Text(
//         wChiTieu.dVT ?? '',
//         style: TextStyle(color: Theme.of(context).hintColor),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
// }
