import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_colors.dart';

class AnimatedToggleSwitch extends StatefulWidget {
  final List<Tags>? tagList;
  final bool? fillRandomColor;
  final Color? fixedColor;
  final Color? iconColor;
  final double? iconSize;
  final double? fontSize;

  const AnimatedToggleSwitch(
      {super.key,
      @required this.tagList,
      @required this.fillRandomColor,
      this.fixedColor,
      this.iconColor,
      this.iconSize,
      this.fontSize})
      : assert(
            fillRandomColor != null &&
                (fillRandomColor == false && fixedColor == null),
            "fixedColor can't be empty.");

  @override
  _AnimatedToggleSwitchState createState() => _AnimatedToggleSwitchState();
}

class _AnimatedToggleSwitchState extends State<AnimatedToggleSwitch> {
  List<Tags> tagList = [];
  bool fillRandomColor = false;
  List<String> selectedCategories = [];
  List<Color> colors = [];
  double iconSize = 24.0;
  double fontSize = 16.0;
  Color iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    this.tagList = widget.tagList ?? [];
    widget.iconColor == null
        ? this.iconColor = Colors.white
        : this.iconColor = widget.iconColor ?? primaryColor;
    widget.fontSize == null
        ? this.fontSize = 16
        : this.fontSize = widget.fontSize ?? 16;
    widget.iconSize == null
        ? this.iconSize = 22
        : this.iconSize = widget.iconSize ?? 24;

    this.fillRandomColor = widget.fillRandomColor ?? false;
    this.colors = getColorList();
    fillRandomColor
        ? randomColorApplyer()
        : fixedColorApplyer(widget.fixedColor ?? primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Wrap(
        children: tagList.map((e) => _buildTag(e)).toList(),
      ),
    );
  }

  Container _buildTag(Tags data) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0, bottom: 15.0),
      decoration: BoxDecoration(
        color: data.getColor(),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                data.isSlected! ? data.isSlected = false : data.isSlected = true;
                data.isSlected!
                    ? selectedCategories.add(data.getTitle()!)
                    : selectedCategories.remove("" + data.getTitle()!);
                data.isSlected!
                    ? data.tagIcon = Icons.check
                    : data.tagIcon = data.developerDefinedIcon;
              });
            },
            child: AnimatedContainer(
              padding: const EdgeInsets.all(4.0),
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white60,
              ),
              child: new Icon(
                data.getIcon(),
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 10.0),
            child: Text(
              "${data.getTitle()}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }

  static List<Color> getColorList() {
    return [
      Colors.orangeAccent,
      Colors.redAccent,
      Colors.lightBlueAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.blueGrey,
      Colors.lightGreen,
    ];
  }

  int genrateRandom(int old) {
    int newRandom = new Random().nextInt(colors.length - 1);
    if (old == newRandom) {
      genrateRandom(old);
    }
    return newRandom;
  }

  void randomColorApplyer() {
    int temp = colors.length + 1;
    for (int i = 0; i <= tagList.length - 1; i++) {
      temp = genrateRandom(temp);
      tagList[i].setTagColor(colors[temp]);
    }
  }

  fixedColorApplyer(Color fixedColor) {
    for (int i = 0; i <= tagList.length - 1; i++) {
      tagList[i].setTagColor(fixedColor);
    }
  }
}

class Tags {
  final String? tagTitle;
  final IconData? developerDefinedIcon;

  IconData? tagIcon;
  bool? isSlected = false;
  Color? tagColor;

  String? getTitle() {
    return tagTitle;
  }

  setTagColor(Color c) {
    this.tagColor = c;
  }

  Color? getColor() {
    return tagColor;
  }

  IconData? getIcon() {
    tagIcon ??= developerDefinedIcon;
    return tagIcon;
  }

  Tags(this.tagTitle, this.developerDefinedIcon)
      : assert(tagTitle != null && developerDefinedIcon != null);
}
