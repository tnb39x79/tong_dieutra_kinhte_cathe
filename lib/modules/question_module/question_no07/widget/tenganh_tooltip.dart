import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_controller.dart';

class TenNganhToolTip extends StatefulWidget {
  const TenNganhToolTip({super.key, this.maSp});

  final String? maSp;

  @override
  State<TenNganhToolTip> createState() => TenNganhToolTipState();
}

class TenNganhToolTipState extends State<TenNganhToolTip> {
  final controller = Get.find<QuestionPhieuTBController>();
  String tenSanPham = '';

  @override
  void initState() {
    super.initState();
    controller.dmMotaSanphamProvider
        .getTenSanPhamByMaSanPham(widget.maSp ?? '')
        .then((item) {
      setState(() {
        tenSanPham = item;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppValues.borderLv1),
              bottomRight: Radius.circular(AppValues.borderLv1)),
          color: const Color.fromARGB(255, 250, 248, 240),
        ),
        child: Text(
          tenSanPham,
          style: styleSmall,
        ));
  }
}
