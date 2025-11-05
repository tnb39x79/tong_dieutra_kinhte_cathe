import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/widgets/categories/widget_row_item.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/model/question/question_group.dart';

class SideBar extends StatelessWidget {
  const SideBar(this.questionGroups, this.onPressed,
      {this.isSelected = false,
      this.drawerTitle,
      this.selectedIndex = 0,
      this.hasNganhVT,
      this.hasNganhLT,
      super.key});

  //final GlobalKey<NavigatorState> navigator;
  final List<QuestionGroupByMaPhieu> questionGroups;
  final bool? isSelected;
  final String? drawerTitle;
  final Function(int, int, QuestionGroupByManHinh) onPressed;
  final bool? hasNganhVT;
  final bool? hasNganhLT;

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: primaryColor),
            height: 50,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    "Nhóm câu hỏi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontMedium,
                        height: textHeight,
                        fontFamily: inter,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          if (drawerTitle != '')
            Row(children: [
              Expanded(
                  child: Center(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Text(
                            drawerTitle!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: warningColor,
                                fontSize: fontMedium,
                                height: textHeight,
                                fontFamily: inter,
                                fontWeight: FontWeight.normal),
                          ))))
            ]),
          Expanded(
              child: ListView.builder(
            itemCount: questionGroups.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (context, index) {
              bool enableTenPhieu = questionGroups[index].enable ?? false;
              String tenPhieu = questionGroups[index].tenPhieu ?? '';
              int idPhieu = questionGroups![index].id!;
              var questionGroupByManHinhs =
                  questionGroups[index].questionGroupByManHinh;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetail(idPhieu, tenPhieu, questionGroupByManHinhs!)
                  ]);
            },
          ))
        ],
      ),
    );
  }

  Widget buildDetail(int idPhieu, String tenPhieu,
      List<QuestionGroupByManHinh> questionGroupByManHinhs) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        margin: const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppValues.borderLv2),
                topRight: Radius.circular(AppValues
                    .borderLv2))), // Adds a gradient background and rounded corners to the container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 0, top: 0, right: 0, bottom: 12),
                margin: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.white, // White shadow with some transparency
                        spreadRadius: 5, // How much the shadow spreads
                        blurRadius: 10, // How blurry the shadow is
                        offset: Offset(0, 5), // X and Y offset of the shadow
                      ),
                    ],
                    color: backgroundColorMau,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppValues.borderLv2),
                        topRight: Radius.circular(AppValues.borderLv2),
                        bottomRight: Radius.circular(AppValues.borderLv2),
                        bottomLeft: Radius.circular(AppValues.borderLv2))),
                // Adds a gradient background and rounded corners to the container
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buildTenPhieu(tenPhieu),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 0, top: 0, right: 0, bottom: 0),
                          margin: const EdgeInsets.only(top: 0),
                          decoration: const BoxDecoration(
                              color: backgroundColorMau,
                              borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(AppValues.borderLv2),
                                  bottomRight: Radius.circular(AppValues
                                      .borderLv2))), // Adds a gradient background and rounded corners to the container
                          child: buildNhomCauHoi(
                              idPhieu, questionGroupByManHinhs!))
                    ])),
          ],
        ));
  }

  Widget buildTenPhieu(String tenPhieu) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
        margin: const EdgeInsets.only(top: 0),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(
                    5.0))), // Adds a gradient background and rounded corners to the container
        child: Text(
          tenPhieu,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 83, 85, 90),
          ),
        ));
  }

  Widget buildNhomCauHoi(
      int idPhieu, List<QuestionGroupByManHinh> questionGroupByManHinhs) {
    return ListView.builder(
      itemCount: questionGroupByManHinhs!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0),
      itemBuilder: (context, index) {
        var itemMH = questionGroupByManHinhs![index];
        var tl = 'Câu ${itemMH.fromQuestion} - câu ${itemMH.toQuestion}';
        if (itemMH.toQuestion == '') {
          tl = 'Câu ${itemMH.fromQuestion} ';
        }
        if (questionGroupByManHinhs![index].fromQuestion == '') {
          tl = 'Câu ${itemMH.toQuestion} ';
        }

        bool enableMnu = itemMH.enable!;
        bool isSelected = itemMH.isSelected!;
        int idManHinh = itemMH.id!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.padding / 2),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.fromLTRB(
                  AppValues.padding / 2,
                  0,
                  AppValues.padding / 2,
                  0,
                ),
                padding: const EdgeInsets.all(0),
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppValues.borderLv2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                          //  color: Colors.lightBlue,
                          child: ListTile(
                        leading: Icon(Icons.help,
                            color: isSelected
                                ? primaryLightColor
                                : enableMnu
                                    ? greyColor
                                    : greyBulliet),
                        title: Text(tl),
                        selected: isSelected,
                        selectedColor: primaryLightColor,
                        enabled: enableMnu,
                        trailing: Icon(
                          Icons.chevron_right,
                          color: questionGroupByManHinhs![index].isSelected!
                              ? primaryLightColor
                              : enableMnu!
                                  ? blackText
                                  : greyColor,
                        ),
                        onTap: () {
                          onPressed(idPhieu, idManHinh, itemMH);
                        },
                      )),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
