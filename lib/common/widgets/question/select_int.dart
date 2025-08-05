// import 'package:flutter/material.dart';
// import 'package:gov_statistics_investigation_economic/common/common.dart';
// import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
// import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm08.dart';  
// import 'package:gov_statistics_investigation_economic/resource/resource.dart';

// class SelectInt extends StatefulWidget {
//   final QuestionCommonModel question;
//   final Function(int) onChange;
//   final List<dynamic> listValue;
//   final Function()? onFinish;
//   final int? value;
//   final ProductModel? product;

//   const SelectInt({
//     Key? key,
//     required this.question,
//     required this.onChange,
//     required this.listValue,
//     this.value,
//     this.onFinish,
//     this.product,
//   }) : super(key: key);

//   @override
//   _SelectIntState createState() => _SelectIntState();
// }

// class _SelectIntState extends State<SelectInt> {
//   int _value = -1;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         RichTextQuestion(
//           widget.question.tenCauHoi ?? '',
//           product: widget.product,
//         ),
//         _buildValues(),
//       ],
//     );
//   }

//   Widget _buildValues() {
    
//     return ListView.builder(
//         shrinkWrap: true,
//         itemCount: widget.listValue.length,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           TableDmDiaDiem item = widget.listValue[index];
//           var name = widget.listValue[index].tenDiaDiem!.split('>>');

//           return CheckBoxCircle(
//             text: name[0],
//             index: index,
//             currentIndex: -1,
//             showIndex: false,
//             styles: styleMedium.copyWith(height: 1.0),
//             isSelected:
//                 _value == item.maDiaDiem || widget.value == item.maDiaDiem,
//             onPressed: (value) {
//               int val = item.maDiaDiem ?? 0;
//               widget.onChange(val);
//               setState(() {
//                 _value = val;
//               });
//             },
//           );
//         });
//   }
// }
