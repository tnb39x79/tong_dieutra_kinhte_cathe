import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
                data.isSlected!
                    ? data.isSlected = false
                    : data.isSlected = true;
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

class AdvancedSwitch extends StatefulWidget {
  const AdvancedSwitch({
    super.key,
    this.controller,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFF9E9E9E),
    this.activeChild,
    this.inactiveChild,
    this.activeImage,
    this.inactiveImage,
    this.borderRadius = const BorderRadius.all(const Radius.circular(15)),
    this.width = 50.0,
    this.height = 30.0,
    this.enabled = true,
    this.disabledOpacity = 0.5,
    this.thumb,
    this.initialValue = false,
    this.onChanged,
  });

  /// Determines if widget is enabled
  final bool enabled;

  /// Determines current state.
  final ValueNotifier<bool>? controller;

  /// Determines background color for the active state.
  final Color activeColor;

  /// Determines background color for the inactive state.
  final Color inactiveColor;

  /// Determines label for the active state.
  final Widget? activeChild;

  /// Determines label for the inactive state.
  final Widget? inactiveChild;

  /// Determines background image for the active state.
  final ImageProvider? activeImage;

  /// Determines background image for the inactive state.
  final ImageProvider? inactiveImage;

  /// Determines border radius.
  final BorderRadius borderRadius;

  /// Determines width.
  final double width;

  /// Determines height.
  final double height;

  /// Determines opacity of disabled control.
  final double disabledOpacity;

  /// Thumb widget.
  final Widget? thumb;

  /// The initial value.
  final bool initialValue;

  /// Called when the value of the switch should change.
  final ValueChanged? onChanged;

  @override
  _AdvancedSwitchState createState() => _AdvancedSwitchState();
}

class _AdvancedSwitchState extends State<AdvancedSwitch>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 250);
  late ValueNotifier<bool> _controller;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;
  late double _thumbSize;
  bool currentState = false;
  @override
  void initState() {
    super.initState();
    currentState = widget.initialValue;
    _controller = ValueNotifier<bool>(widget.initialValue);

    _valueController.addListener(_handleControllerValueChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: _controller.value ? 1.0 : 0.0,
    );

    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant AdvancedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller?.removeListener(_handleControllerValueChanged);
    _valueController
      ..removeListener(_handleControllerValueChanged)
      ..addListener(_handleControllerValueChanged);

    if (oldWidget.initialValue != widget.initialValue) {
      _valueController.value = widget.initialValue;
    }

    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final labelSize = widget.width - _thumbSize;
    final containerSize = labelSize * 2 + _thumbSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handlePressed,
        child: Opacity(
          opacity: _isEnabled ? 1 : widget.disabledOpacity,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              return ClipRRect(
                borderRadius: widget.borderRadius,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  color: _colorAnimation.value,
                  child: child,
                ),
              );
            },
            child: Stack(
              children: [
                if (widget.activeImage != null || widget.inactiveImage != null)
                  ValueListenableBuilder<bool>(
                    valueListenable: _valueController,
                    builder: (_, value, ___) {
                      print('value: $value');

                      return AnimatedCrossFade(
                        crossFadeState: value
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: _duration,
                        firstChild: Image(
                          width: widget.width,
                          height: widget.height,
                          image: widget.inactiveImage ?? widget.activeImage!,
                          fit: BoxFit.cover,
                        ),
                        secondChild: Image(
                          width: widget.width,
                          height: widget.height,
                          image: widget.activeImage ?? widget.inactiveImage!,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _slideAnimation.value,
                      child: child,
                    );
                  },
                  child: OverflowBox(
                    minWidth: containerSize,
                    maxWidth: containerSize,
                    minHeight: widget.height,
                    maxHeight: widget.height,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconTheme(
                          data: const IconThemeData(
                            color: Color(0xFFFFFFFF),
                            size: 20,
                          ),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 2),
                              width: labelSize,
                              height: widget.height,
                              alignment: Alignment.center,
                              child: widget.activeChild,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(2),
                          width: _thumbSize - 6,
                          height: _thumbSize - 6,
                          child: widget.thumb ??
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: widget.borderRadius
                                      .subtract(BorderRadius.circular(1)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x42000000),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  size: 16.0,
                                  (currentState == true)
                                      ? Icons.wifi_outlined
                                      : Icons.wifi_off_outlined,
                                  color: (currentState == true)
                                      ? widget.activeColor
                                      : widget.inactiveColor,
                                ),
                              ),
                        ),
                        IconTheme(
                          data: const IconThemeData(
                            color: Color(0xFFFFFFFF),
                            size: 20,
                          ),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            child: Container(
                              width: labelSize,
                              height: widget.height,
                              alignment: Alignment.center,
                              child: widget.inactiveChild,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ValueNotifier<bool> get _valueController => widget.controller ?? _controller;

  bool get _isEnabled =>
      widget.enabled && (widget.controller != null || widget.onChanged != null);

  void _initAnimation() {
    _thumbSize = widget.height;
    final offset = widget.width / 2 - _thumbSize / 2;

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-offset, 0),
      end: Offset(offset, 0),
    ).animate(animation);

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(animation);
  }

  void _handleControllerValueChanged() {
    final nextValue = _valueController.value;
    widget.onChanged?.call(nextValue);

    if (nextValue) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    setState(() {
      currentState = nextValue;
    });
  }

  void _handlePressed() {
    if (!_isEnabled) {
      return;
    }

    _valueController.value = !_valueController.value;
  }

  @override
  void dispose() {
    _valueController.removeListener(_handleControllerValueChanged);

    _controller..dispose();

    _animationController.dispose();

    super.dispose();
  }
}
