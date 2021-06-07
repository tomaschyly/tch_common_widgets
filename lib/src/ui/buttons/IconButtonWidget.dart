import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';

class IconButtonWidget extends StatelessWidget {
  final IconButtonStyle? style;
  final String? svgAssetPath;
  final Widget? iconWidget;
  final GestureTapCallback? onTap;

  /// IconButtonWidget initialization
  IconButtonWidget({
    this.style,
    this.svgAssetPath,
    this.iconWidget,
    this.onTap,
  }) : assert(svgAssetPath != null || iconWidget != null);

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final IconButtonVariant variant = (style?.variant ?? commonTheme?.buttonsStyle.iconButtonStyle.variant) ?? IconButtonVariant.Outlined;

    final width = (style?.width ?? commonTheme?.buttonsStyle.iconButtonStyle.width) ?? kMinInteractiveSize;
    final height = (style?.height ?? commonTheme?.buttonsStyle.iconButtonStyle.height) ?? kMinInteractiveSize;
    final iconWidth = (style?.iconWidth ?? commonTheme?.buttonsStyle.iconButtonStyle.iconWidth) ?? kIconSize;
    final iconHeight = (style?.iconHeight ?? commonTheme?.buttonsStyle.iconButtonStyle.iconHeight) ?? kIconSize;

    final color = style?.color ?? commonTheme?.buttonsStyle.iconButtonStyle.color ?? Colors.black;
    final iconColor = style?.iconColor ?? commonTheme?.buttonsStyle.iconButtonStyle.iconColor ?? color;

    late Widget icon;

    if (iconWidget != null) {
      icon = Container(
        width: iconWidth,
        height: iconHeight,
        child: iconWidget,
      );
    } else {
      icon = SvgPicture.asset(
        svgAssetPath!,
        width: iconWidth,
        height: iconHeight,
        color: iconColor,
      );
    }

    final BorderRadius? borderRadius = style?.borderRadius ?? commonTheme?.buttonsStyle.iconButtonStyle.borderRadius;
    final boxShadow = style?.boxShadow ?? commonTheme?.buttonsStyle.iconButtonStyle.boxShadow;

    Widget content = Material(
      color: variant == IconButtonVariant.Filled ? color : Colors.transparent,
      child: InkWell(
        child: Container(
          width: width,
          height: height,
          decoration: variant == IconButtonVariant.IconOnly
              ? null
              : BoxDecoration(
                  color: variant == IconButtonVariant.Filled ? color : Colors.transparent,
                  border: Border.all(
                    color: color,
                    width: 1,
                  ),
                  borderRadius: borderRadius,
                  boxShadow: boxShadow,
                ),
          child: Center(
            child: icon,
          ),
        ),
        onTap: onTap,
      ),
    );

    if (borderRadius != null) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: content,
      );
    }

    if (boxShadow != null) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: content,
      );
    }

    final bool canBeStretched = style?.canBeStretched ?? commonTheme?.buttonsStyle.iconButtonStyle.canBeStretched ?? false;
    if (!canBeStretched) {
      content = Container(
        width: width,
        height: height,
        child: Center(child: content),
      );
    }

    return content;
  }
}

enum IconButtonVariant {
  None,
  Outlined,
  Filled,
  IconOnly,
}

class IconButtonStyle {
  final IconButtonVariant variant;
  final double width;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final Color? color;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool? canBeStretched;

  /// IconButtonStyle initialization
  const IconButtonStyle({
    this.variant = IconButtonVariant.Outlined,
    this.width = kMinInteractiveSize,
    this.height = kMinInteractiveSize,
    this.iconWidth = kIconSize,
    this.iconHeight = kIconSize,
    this.color = Colors.black,
    this.iconColor,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
    this.boxShadow,
    this.canBeStretched,
  });

  /// Create copy if this style with changes
  IconButtonStyle copyWith({
    IconButtonVariant? variant,
    double? width,
    double? height,
    double? iconWidth,
    double? iconHeight,
    Color? color,
    Color? iconColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    bool? canBeStretched,
  }) {
    return IconButtonStyle(
      variant: variant ?? this.variant,
      width: width ?? this.width,
      height: height ?? this.height,
      iconWidth: iconWidth ?? this.iconWidth,
      iconHeight: iconHeight ?? this.iconHeight,
      color: color ?? this.color,
      iconColor: iconColor ?? this.iconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      canBeStretched: canBeStretched ?? this.canBeStretched,
    );
  }
}
