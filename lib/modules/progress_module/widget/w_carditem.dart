import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
 
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/widget_progress.dart';

class WCardItem extends StatelessWidget {
  const WCardItem(
      {super.key,
      required this.doiTuongDT,
      required this.countTotal,
      required this.countInterviewed,
      required this.countUnInterviewed,
      required this.countSyncSuccess,
      required this.countUnSync});

  final String doiTuongDT;
  final int countTotal;
  final int countInterviewed;
  final int countUnInterviewed;
  final int countSyncSuccess;
  final int countUnSync;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.paddingBox,
          0,
          AppValues.paddingBox,
          AppValues.paddingBox,
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, AppValues.paddingBox),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cardBodyV2(),
      ],
    );
  }

  Widget cardBodyV2() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cardBodyItem('Tổng số cơ sở', countTotal.toString()),
          cardBodyItem('Đã phỏng vấn', countInterviewed.toString(), level: 2),
          cardBodyItem('Chưa phỏng vấn', countUnInterviewed.toString(),
              level: 2),
          cardBodyItem('Đã đồng bộ', countSyncSuccess.toString(), level: 2),
          cardBodyItem('Chưa đồng bộ', countUnSync.toString(), level: 2)
        ]);
  }

  Widget cardBodyItem(
    String title,
    String value, {
    level = 1,
  }) {
    final style = TextStyle(
      fontSize: level == 1 ? fontLarge : fontMedium,
      fontWeight: level == 1 ? FontWeight.bold : FontWeight.normal,
    );

    final EdgeInsetsGeometry padding = level == 1
        ? const EdgeInsets.only(
            top: AppValues.padding,
            bottom: AppValues.padding,
            left: AppValues.padding,
            right: AppValues.padding,
          )
        : const EdgeInsets.only(
            top: AppValues.padding / 2,
            bottom: AppValues.padding / 2,
            left: AppValues.padding + 16,
            right: AppValues.padding,
          );
    return Container(
      padding: padding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: style,
              ),
              Text(
                value,
                style: style,
              )
            ],
          ),
          if (level == 1) const Divider()
        ],
      ),
    );
  }

  Widget cardBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetProgress(
          title: 'Tổng số cơ sở',
          count: countTotal,
          onPressed: () {},
        ),
        Divider(),
        WidgetProgress(
          title: 'progress_interviewed'.tr,
          count: countInterviewed,
          onPressed: () {},
        ),
        WidgetProgress(
          title: 'progress_un_interviewed'.tr,
          count: countUnInterviewed,
          onPressed: () {},
        ),
        WidgetProgress(
          title: 'progress_sync_success'.tr,
          count: countSyncSuccess,
          onPressed: () {},
        ),
        WidgetProgress(
          title: 'progress_unsync'.tr,
          count: countUnSync,
          onPressed: () {},
        ),
      ],
    );
  }
}