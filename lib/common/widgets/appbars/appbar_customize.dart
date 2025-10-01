import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_styles.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.title,
      this.titleEnd,
      required this.onPressedLeading,
      required this.iconLeading,
      this.questionCode = 0,
      this.actions,
      this.backAction,
      this.subTitle,
      this.wTitle});

  final Widget? wTitle;
  final String? title;
  final String? titleEnd;
  final String? subTitle;
  final Function() onPressedLeading;
  final Widget? iconLeading;
  final Widget? actions;
  final int questionCode;
  final Function()? backAction;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight); // kToolbarHeight is a common default AppBar height
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    var currentTitle = (widget.subTitle == null || widget.subTitle == "")
        ? Text(widget.title!, style: styleMediumBold)
        : ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(widget.title!, style: styleMediumBoldAppBarHeader),
            subtitle: Text(widget.subTitle!,
                style: const TextStyle(color: Colors.white)),
            titleAlignment: ListTileTitleAlignment.center,
          );
    if (widget.wTitle != null) {}
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      actions: [widget.actions ?? actionDefault()],
      // title: Text(getTitleAppBar(), style: styleMediumBold),
      title: widget.wTitle ?? currentTitle,
      leading: IconButton(
          onPressed: () {
            if (widget.backAction != null) {
              widget.backAction!();
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
