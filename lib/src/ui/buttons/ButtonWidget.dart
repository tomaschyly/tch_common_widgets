import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';

class ButtonWidget extends AbstractStatefulWidget {
  final CommonButtonStyle? style;
  final String text;
  final String? prefixIconSvgAssetPath;
  final Widget? prefixIcon;
  final GestureTapCallback? onTap;
  final bool isLoading;

  /// ButtonWidget initialization
  ButtonWidget({
    this.style,
    required this.text,
    this.prefixIconSvgAssetPath,
    this.prefixIcon,
    this.onTap,
    this.isLoading = false,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends AbstractStatefulWidgetState<ButtonWidget> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  /// Manually dispose of resources
  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;

    super.dispose();
  }

  /// Widget parameters changed
  @override
  void didUpdateWidget(covariant ButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _initLoadingAnimation(context);
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _stopLoadingAnimation();
        });
      }
    }
  }

  /// Run initializations of widget on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    if (widget.isLoading) {
      _initLoadingAnimation(context);
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.buttonsStyle.fullWidthMobileOnly ?? true;

    final theVariant = widget.style?.variant ?? commonTheme?.buttonsStyle.buttonStyle.variant ?? ButtonVariant.Outlined;

    final color = widget.style?.color ?? commonTheme?.buttonsStyle.buttonStyle.color ?? Colors.black;
    final iconColor = widget.style?.iconColor ?? commonTheme?.buttonsStyle.buttonStyle.iconColor ?? color;

    final BorderRadius? borderRadius = widget.style?.borderRadius ?? commonTheme?.buttonsStyle.buttonStyle.borderRadius;
    final boxShadow = widget.style?.boxShadow ?? commonTheme?.buttonsStyle.buttonStyle.boxShadow;

    late Widget inner;

    if (widget.isLoading) {
      final loadingIconSvgAssetPath = widget.style?.loadingIconSvgAssetPath ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconSvgAssetPath;
      final loadingIcon = widget.style?.loadingIcon ?? commonTheme?.buttonsStyle.buttonStyle.loadingIcon;
      final loadingIconWidth = widget.style?.loadingIconWidth ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconWidth ?? kIconSize;
      final loadingIconHeight = widget.style?.loadingIconHeight ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconHeight ?? kIconSize;

      Widget? icon;
      if (loadingIcon != null) {
        icon = Container(
          width: loadingIconWidth,
          height: loadingIconHeight,
          child: loadingIcon,
        );
      } else if (loadingIconSvgAssetPath != null) {
        icon = SvgPicture.asset(
          loadingIconSvgAssetPath,
          width: loadingIconWidth,
          height: loadingIconHeight,
          color: iconColor,
        );
      }

      inner = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animationController!,
            builder: (BuildContext context, Widget? child) {
              if (loadingIconSvgAssetPath != null || loadingIcon != null) {
                return Transform.rotate(
                  angle: _animationController!.value * 2 * pi,
                  child: child,
                );
              } else {
                return Transform.rotate(
                  angle: _animationController!.value * 2 * pi,
                  child: Container(
                    width: loadingIconWidth,
                    height: loadingIconHeight,
                    child: CircularProgressIndicator(
                      color: iconColor,
                      value: 0.25,
                    ),
                  ),
                );
              }
            },
            child: icon,
          ),
        ],
      );
    } else {
      final preffixIconWidth = widget.style?.preffixIconWidth ?? commonTheme?.buttonsStyle.buttonStyle.preffixIconWidth ?? kIconSize;
      final preffixIconHeight = widget.style?.preffixIconHeight ?? commonTheme?.buttonsStyle.buttonStyle.preffixIconHeight ?? kIconSize;

      Widget? prefixIcon;

      if (widget.prefixIcon != null) {
        prefixIcon = Container(
          width: preffixIconWidth,
          height: preffixIconHeight,
          child: widget.prefixIcon,
        );
      } else if (widget.prefixIconSvgAssetPath != null) {
        prefixIcon = SvgPicture.asset(
          widget.prefixIconSvgAssetPath!,
          width: preffixIconWidth,
          height: preffixIconHeight,
          color: iconColor,
        );
      }

      final prefixIconSpacing = widget.style?.prefixIconSpacing ?? commonTheme?.buttonsStyle.buttonStyle.prefixIconSpacing ?? kCommonHorizontalMargin;

      TextStyle? textStyle;
      if (theVariant == ButtonVariant.Filled) {
        textStyle = widget.style?.filledTextStyle ?? commonTheme?.buttonsStyle.buttonStyle.filledTextStyle;
      } else {
        textStyle = widget.style?.textStyle ?? commonTheme?.buttonsStyle.buttonStyle.textStyle;
      }
      if (textStyle != null && commonTheme != null) {
        textStyle = commonTheme.preProcessTextStyle(textStyle);
      }

      inner = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon,
            Container(
              width: prefixIconSpacing,
            ),
          ],
          Text(
            widget.text,
            style: textStyle,
          ),
        ],
      );
    }

    final widthWrapContent = widget.style?.widthWrapContent ?? commonTheme?.buttonsStyle.buttonStyle.widthWrapContent ?? false;
    final width = widget.style?.width ?? commonTheme?.buttonsStyle.buttonStyle.width ?? double.infinity;
    final height = widget.style?.height ?? commonTheme?.buttonsStyle.buttonStyle.height ?? kMinInteractiveSize;
    final contentPadding =
        widget.style?.contentPadding ?? commonTheme?.buttonsStyle.buttonStyle.contentPadding ?? const EdgeInsets.symmetric(horizontal: kCommonHorizontalMargin);

    Widget content = Material(
      color: theVariant == ButtonVariant.Filled ? color : Colors.transparent,
      child: InkWell(
        child: Container(
          width: widthWrapContent ? null : (fullWidthMobileOnly ? kPhoneStopBreakpoint : width),
          height: height,
          padding: contentPadding,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: theVariant == ButtonVariant.TextOnly ? Colors.transparent : color,
              width: 1,
            ),
            borderRadius: borderRadius,
          ),
          child: inner,
        ),
        onTap: widget.onTap,
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

    return content;
  }

  /// Initialize loading animation and start repeating
  void _initLoadingAnimation(BuildContext context) {
    final loadingAnimationDuration =
        widget.style?.loadingAnimationDuration ?? CommonTheme.of(context)?.buttonsStyle.buttonStyle.loadingAnimationDuration ?? Duration(milliseconds: 1200);

    _animationController = AnimationController(
      vsync: this,
      duration: loadingAnimationDuration,
    );
    _animationController!.repeat();
  }

  /// Stop loading animation from running
  void _stopLoadingAnimation() {
    _animationController!.stop();

    _animationController!.dispose();

    _animationController = null;
  }
}

enum ButtonVariant {
  None,
  Outlined,
  Filled,
  TextOnly,
}

class CommonButtonStyle {
  final ButtonVariant variant;
  final TextStyle textStyle;
  final TextStyle filledTextStyle;
  final bool widthWrapContent;
  final double width;
  final double height;
  final EdgeInsets contentPadding;
  final double preffixIconWidth;
  final double preffixIconHeight;
  final Color? color;
  final Color? iconColor;
  final double prefixIconSpacing;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final String? loadingIconSvgAssetPath;
  final Widget? loadingIcon;
  final double loadingIconWidth;
  final double loadingIconHeight;
  final Duration loadingAnimationDuration;

  /// CommonButtonStyle initialization
  const CommonButtonStyle({
    this.variant = ButtonVariant.Outlined,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.filledTextStyle = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    this.widthWrapContent = false,
    this.width = double.infinity,
    this.height = kMinInteractiveSize,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: kCommonHorizontalMargin),
    this.preffixIconWidth = kIconSize,
    this.preffixIconHeight = kIconSize,
    this.color = Colors.black,
    this.iconColor,
    this.prefixIconSpacing = kCommonHorizontalMargin,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
    this.boxShadow,
    this.loadingIconSvgAssetPath,
    this.loadingIcon,
    this.loadingIconWidth = kIconSize,
    this.loadingIconHeight = kIconSize,
    this.loadingAnimationDuration = const Duration(milliseconds: 1200),
  });

  /// Create copy of this style with changes
  CommonButtonStyle copyWith({
    ButtonVariant? variant,
    TextStyle? textStyle,
    TextStyle? filledTextStyle,
    bool? widthWrapContent,
    double? width,
    double? height,
    EdgeInsets? contentPadding,
    double? preffixIconWidth,
    double? preffixIconHeight,
    Color? color,
    Color? iconColor,
    double? prefixIconSpacing,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    String? loadingIconSvgAssetPath,
    Widget? loadingIcon,
    double? loadingIconWidth,
    double? loadingIconHeight,
    Duration? loadingAnimationDuration,
  }) {
    return CommonButtonStyle(
      variant: variant ?? this.variant,
      textStyle: textStyle ?? this.textStyle,
      filledTextStyle: filledTextStyle ?? this.filledTextStyle,
      widthWrapContent: widthWrapContent ?? this.widthWrapContent,
      width: width ?? this.width,
      height: height ?? this.height,
      contentPadding: contentPadding ?? this.contentPadding,
      preffixIconWidth: preffixIconWidth ?? this.preffixIconWidth,
      preffixIconHeight: preffixIconHeight ?? this.preffixIconHeight,
      color: color ?? this.color,
      iconColor: iconColor ?? this.iconColor,
      prefixIconSpacing: prefixIconSpacing ?? this.prefixIconSpacing,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      loadingIconSvgAssetPath: loadingIconSvgAssetPath ?? this.loadingIconSvgAssetPath,
      loadingIcon: loadingIcon ?? this.loadingIcon,
      loadingIconWidth: loadingIconWidth ?? this.loadingIconWidth,
      loadingIconHeight: loadingIconHeight ?? this.loadingIconHeight,
      loadingAnimationDuration: loadingAnimationDuration ?? this.loadingAnimationDuration,
    );
  }
}
