import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';

class WTitleHeader extends StatelessWidget {
  const WTitleHeader({super.key, required this.titleHeader,this.isSuccess});

  final String titleHeader;
  final bool? isSuccess;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: const EdgeInsets.fromLTRB(
                    AppValues.padding, 0, AppValues.padding, 4),
                child: Text(titleHeader, style: isSuccess!? styleLargeBold.copyWith(color: successColor): styleLargeBold.copyWith(color: errorColor)),
              )
            ]))
      ],
    );
  }
}
