import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';

class WCardHeader extends StatelessWidget {
  const WCardHeader({super.key, required this.titleHeader});

  final String titleHeader;
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
                      padding: const EdgeInsets.fromLTRB(AppValues.padding, 0, AppValues.padding, 4),
                    child: Text(titleHeader, style: styleLargeBold),
                  )
              
            ]
            )
          )
      ],
    );
  }
}
