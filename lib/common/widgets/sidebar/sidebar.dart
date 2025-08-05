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
      this.hasPhanVI,
      this.hasPhanVII,
      super.key});

  //final GlobalKey<NavigatorState> navigator;
  final List<QuestionGroup> questionGroups;
  final bool? isSelected;
  final String? drawerTitle;
  final Function(int) onPressed;
  final bool? hasPhanVI;
  final bool? hasPhanVII;

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
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
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.only(top: 6),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Text(
                      drawerTitle!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: warningColor,
                          fontSize: fontMedium,
                          height: textHeight,
                          fontFamily: inter,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
              child: ListView.builder(
            itemCount: questionGroups.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (context, index) {
              var tl =
                  'Câu ${questionGroups[index].fromQuestion} - câu ${questionGroups[index].toQuestion}';
              if (questionGroups[index].toQuestion == '') {
                tl = 'Câu ${questionGroups[index].fromQuestion} ';
              }
              if (questionGroups[index].fromQuestion == '') {
                tl = 'Câu ${questionGroups[index].toQuestion} ';
              }
              bool enableMnu = questionGroups[index].enable!;
              // if (questionGroups[index].fromQuestion == "6.1") {
              //   enableMnu = hasPhanVI != null && hasPhanVI == true;
              // } else if (questionGroups[index].fromQuestion == "7.1") {
              //   enableMnu = hasPhanVII != null && hasPhanVII == true;
              // }

              return Column(
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
                        borderRadius:
                            BorderRadius.circular(AppValues.borderLv2),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                                //  color: Colors.lightBlue,
                                child: ListTile(
                              leading: Icon(Icons.help,
                                  color: questionGroups[index].isSelected!
                                      ? primaryLightColor
                                      : questionGroups[index].enable!
                                          ? greyColor
                                          : greyBulliet),
                              title: Text(tl),
                              selected: questionGroups[index].isSelected!,
                              selectedColor: primaryLightColor,
                              enabled: enableMnu,
                              trailing: Icon(
                                Icons.chevron_right,
                                color: questionGroups[index].isSelected!
                                    ? primaryLightColor
                                    : questionGroups[index].enable!
                                        ? blackText
                                        : greyColor,
                              ),
                              onTap: () {
                                onPressed(questionGroups[index].id!);
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
          ))
        ],
      ),
    );
  }
}
