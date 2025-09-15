import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/question/input_string.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/checkbox_circle_dm.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/widget/input_string_dm.dart';
 
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm07mau.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_gioitinh.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class SelectIntCTDm extends StatefulWidget {
  final QuestionCommonModel question;
  final Function(int, dynamic) onChange;
  final List<dynamic> listValue;
  final String? tenDanhMuc;
  final Function()? onFinish;
  final int? value;
  final ProductModel? product;
  final String? titleGhiRoText;
  final bool? hienThiTenCauHoi;
  final Function(String?, dynamic)? onChangeGhiRo;
  final bool? isbg; 

  const SelectIntCTDm(
      {super.key,
      required this.question,
      required this.onChange,
      required this.listValue,
      required this.tenDanhMuc,
      this.value,
      this.onFinish,
      this.product,
      this.titleGhiRoText,
      this.onChangeGhiRo,
      this.hienThiTenCauHoi,
      this.isbg });

  @override
  SelectIntCTDmState createState() => SelectIntCTDmState();
}

class SelectIntCTDmState extends State<SelectIntCTDm> {
  int _value = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTenCauHoi(),
        _buildValues(),
      ],
    );
  }

  Widget buildTenCauHoi() {
    if (widget.hienThiTenCauHoi != null && widget.hienThiTenCauHoi == false) {
      if (widget.titleGhiRoText != null && widget.titleGhiRoText != '') {
        return RichTextQuestion(
          widget.titleGhiRoText!,
          product: widget.product,
          level: 3,
        );
      }
      return const SizedBox();
    }

    return RichTextQuestion(
      widget.question.tenCauHoi ?? '',
      product: widget.product,
    );
  }

  Widget _buildValues() {
    if (widget.isbg != null && widget.isbg == true) {
      return Container(
          margin: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: greyDarkBorder, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white),
          child: wWidgetListView());
    }
    return wWidgetListView();
  }

  Widget wWidgetListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listValue.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int maVal = 0;
          String tenVal = '';
          dynamic itemDyn;
          int ghiRo = 0;
          if (widget.tenDanhMuc == tableCTDmDiaDiemSXKD) {
            TableCTDmDiaDiemSXKD item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          // } else if (widget.tenDanhMuc == tableDmCap) {
          //   TableDmCap item = widget.listValue[index];
          //   itemDyn = item;
          //   maVal = item.ma!;
          //   tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableCTDmHoatDongLogistic) {
            TableCTDmHoatDongLogistic item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableCTDmLinhVuc) {
            TableCTDmLinhVuc item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableCTDmLoaiDiaDiem) {
            TableCTDmLoaiDiaDiem item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableCTDmTinhTrangDKKD) {
            TableCTDmTinhTrangDKKD item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableCTDmTrinhDoCm) {
            TableCTDmTrinhDoChuyenMon item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmGioiTinh) {
            TableDmGioiTinh item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmCoKhong) {
            TableDmCoKhong item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmQuocTich) {
            TableCTDmQuocTich item = widget.listValue[index];
            itemDyn = item;
            maVal = item.maQuocTich!;
            tenVal = item.tenQuocTich!;
          }
          return Column(
            children: [
              CheckBoxCircleDm(
                text: tenVal,
                index: index,
                currentIndex: -1,
                showIndex: false,
                styles: styleMedium.copyWith(height: 1.0),
                isSelected: ((_value == maVal || widget.value == maVal) &&
                    widget.value != null),
                onPressed: (value) {
                  int val = maVal;
                  widget.onChange(val, itemDyn);
                  setState(() {
                    _value = val;
                  });
                },
              ),
              //   buildGhiRo(ghiRo, itemDyn)
            ],
          );
        });
  }

  Widget buildGhiRo(int ghiRo, dmItem) {
    if (ghiRo != 0) {
      return InputStringDm(
          question: widget.question,
          titleText: widget.titleGhiRoText,
          onChange: (String? value) =>
              widget.onChangeGhiRo ??
              widget.onChangeGhiRo!(value != '' ? value : null, dmItem));
    }
    return const SizedBox();
  }

  
}
