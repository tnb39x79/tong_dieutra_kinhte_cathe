import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
 
import 'package:gov_statistics_investigation_economic/modules/progress_module/widget/widget_progress.dart';

class WCardItem extends StatelessWidget {
  const WCardItem({
    super.key,
    required this.doiTuongDT,
    required this.countInterviewed,
    required this.countUnInterviewed,
    required this.countSyncSuccess,
  });

  final String doiTuongDT;
  final int countInterviewed;
  final int countUnInterviewed;
  final int countSyncSuccess;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding,
          0,
          AppValues.padding,
          AppValues.padding,
        ),
        padding: const EdgeInsets.all(AppValues.padding),
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
        cardBody(),
      ],
    );
  }

  Widget cardBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetProgress(
          title: doiTuongDT == '${AppDefine.maDoiTuongDT_07Mau}'
              ? ('progress_interviewed'.tr).replaceAll("hộ", "cơ sở")
              : 'progress_interviewed'.tr,
          count: countInterviewed,
          onPressed: () {},
        ),
        WidgetProgress(
          title: doiTuongDT == '${AppDefine.maDoiTuongDT_07Mau}'
              ? ('progress_un_interviewed'.tr).replaceAll("hộ", "cơ sở")
              : 'progress_un_interviewed'.tr,
          count: countUnInterviewed,
          onPressed: () {},
        ),
        WidgetProgress(
          title: doiTuongDT == '${AppDefine.maDoiTuongDT_07Mau}'
              ? ('progress_sync_success'.tr).replaceAll("hộ", "cơ sở")
              : 'progress_sync_success'.tr,
          count: countSyncSuccess,
          onPressed: () {},
        ),
      ],
    );
  }
}
