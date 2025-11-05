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
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight + 10); // kToolbarHeight is a common default AppBar height
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    var allText = '${widget.subTitle} ${widget.subTitle}';
    var currentTitle = (widget.subTitle == null || widget.subTitle == "")
        ? Text(
            widget.title!,
            style: styleMediumBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(widget.title!, style: styleMediumBoldAppBarHeader),
            subtitle: Text(widget.subTitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white)),
            titleAlignment: ListTileTitleAlignment.center,
          );

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [widget.actions ?? actionDefault()],
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

  double calculateTextHeight(String text, TextStyle style) {
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr, // Or appropriate text direction
      maxLines: null, // Allow multiple lines
    )..layout(maxWidth: screenWidth);
    return textPainter.height;
  }

  Widget actionDefault() {
    // return IconButton(onPressed: () {}, icon: const Icon(Icons.location_on));
    return const SizedBox();
  }
}
