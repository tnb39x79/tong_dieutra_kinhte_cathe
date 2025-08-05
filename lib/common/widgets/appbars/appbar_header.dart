/// The app bar for question screen
/// params: questionCode: maPhieu,

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';
// import 'package:gov_statistics_investigation_economic/modules/modules.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeader(
      {Key? key,
      this.title,
      this.titleEnd,
      required this.onPressedLeading,
      required this.iconLeading,
      this.questionCode = 0,
      this.actions,
      this.backAction,
      this.subTitle})
      : super(key: key);

  final String? title;
  final String? titleEnd;
  final String? subTitle;
  final Function() onPressedLeading;
  final Widget? iconLeading;
  final Widget? actions;
  final int questionCode;
  final Function()? backAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      actions: [actions ?? actionDefault()],
      // title: Text(getTitleAppBar(), style: styleMediumBold),
      title: (subTitle == null || subTitle == "")
          ? Text(title!, style: styleMediumBold)
          : ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              title: Text(title!, style: styleMediumBoldAppBarHeader),
              subtitle:
                  Text(subTitle!, style: const TextStyle(color: Colors.white)),
              titleAlignment: ListTileTitleAlignment.center,
            ),
      leading: IconButton(
          onPressed: () {
            if (backAction != null) {
              backAction!();
            } else {
              Get.back();
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget actionDefault() {
    // return IconButton(onPressed: () {}, icon: const Icon(Icons.location_on));
    return const SizedBox();
  }
}
