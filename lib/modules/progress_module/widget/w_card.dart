import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/w_cardheader.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/w_carditem.dart';

class WCard extends StatelessWidget {
  const WCard({
    super.key,
    required this.titleHeader,
    required this.doiTuongDT,
    required this.countTotal,
    required this.countInterviewed,
    required this.countUnInterviewed,
    required this.countSyncSuccess,
    required this.countUnSync,
  });

  final String titleHeader;
  final String doiTuongDT;
  final int countTotal;
  final int countInterviewed;
  final int countUnInterviewed;
  final int countSyncSuccess;
  final int countUnSync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (titleHeader != '') WCardHeader(titleHeader: titleHeader),
        WCardItem(
            doiTuongDT: doiTuongDT,
            countTotal: countTotal,
            countInterviewed: countInterviewed,
            countUnInterviewed: countUnInterviewed,
            countSyncSuccess: countSyncSuccess,
            countUnSync: countUnSync)
      ],
    );
  }
}
