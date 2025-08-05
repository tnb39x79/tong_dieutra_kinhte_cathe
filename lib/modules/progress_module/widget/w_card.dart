import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/w_cardheader.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/w_carditem.dart';

class WCard extends StatelessWidget {
  const WCard({
    super.key,
    required this.titleHeader,
    required this.doiTuongDT,
    required this.countInterviewed,
    required this.countUnInterviewed,
    required this.countSyncSuccess,
  });

  final String titleHeader;
  final String doiTuongDT;
  final int countInterviewed;
  final int countUnInterviewed;
  final int countSyncSuccess;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WCardHeader(titleHeader: titleHeader),
        WCardItem(
            doiTuongDT: doiTuongDT,
            countInterviewed: countInterviewed,
            countUnInterviewed: countUnInterviewed,
            countSyncSuccess: countSyncSuccess)
      ],
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //       child: Column(
  //         children: [
  //           WCardHeader(titleHeader: titleHeader),
  //           WCardItem(
  //               doiTuongDT: doiTuongDT,
  //               countInterviewed: countInterviewed,
  //               countUnInterviewed: countUnInterviewed,
  //               countSyncSuccess: countSyncSuccess)
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
