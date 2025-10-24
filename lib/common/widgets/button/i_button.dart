import 'package:flutter/material.dart';
import 'package:gov_statistics_investigation_economic/config/config.dart';

enum IButtonType { inline, outline, text }

const BUTTON_HEIGHT = 40.0;

class IButton extends StatelessWidget {
  const IButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = IButtonType.inline,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.backgroundColor,
    this.disabledColor,
    this.textStyle,
    this.borderColor,
    this.leftIcon,
    this.rightIcon,
    this.child,
    this.height = BUTTON_HEIGHT,
  });
  final Widget? child;
  final String label;
  final VoidCallback? onPressed;
  final IButtonType type;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? disabledColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double height;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case IButtonType.inline:
        return _buildInlineButton();
      case IButtonType.outline:
        return _buildOutlineButton();
      case IButtonType.text:
        return _buildTextButton();
    }
  }

  Widget _buildInlineButton() {
    Color oColor = primaryColor.withValues(alpha: 0.2);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        splashFactory: InkRipple.splashFactory,
        overlayColor: oColor,
        padding: padding,
        backgroundColor: _isDisabled
            ? (disabledColor ?? backgroundDisableColor)
            : (backgroundColor ?? primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderLv1),
        ),
        elevation: 0,
        minimumSize: Size.fromHeight(height),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leftIcon != null) ...[
                leftIcon!,
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: styleMedium
                    .copyWith(
                      color: _isDisabled ? Colors.white70 : Colors.white,
                    )
                    .merge(textStyle),
              ),
              if (rightIcon != null) ...[
                const SizedBox(width: 8),
                rightIcon!,
              ],
            ],
          ),
    );
  }

  Widget _buildOutlineButton() {
    final Color effectiveBorderColor = _isDisabled
        ? (disabledColor ?? backgroundDisableColor)
        : (borderColor ?? primaryColor);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding,
        side: BorderSide(color: effectiveBorderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderLv1),
        ),
        minimumSize: Size.fromHeight(height),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkRipple.splashFactory, 
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leftIcon != null) ...[
            leftIcon!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: styleMedium
                .copyWith(color: effectiveBorderColor)
                .merge(textStyle),
          ),
          if (rightIcon != null) ...[
            const SizedBox(width: 8),
            rightIcon!,
          ],
        ],
      ),
    );
  }

  Widget _buildTextButton() {
    final Color effectiveTextColor = _isDisabled
        ? (disabledColor ?? backgroundDisableColor)
        : (backgroundColor ?? primaryColor);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderLv1),
        ),
        minimumSize: Size.fromHeight(height),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: styleMedium.copyWith(color: effectiveTextColor).merge(textStyle),
      ),
    );
  }
}
