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
  final String? suffixIconSvgAssetPath;
  final Widget? suffixIcon;
  final GestureTapCallback? onTap;
  final bool? isLoading;
  final List<String> loadingTags;

  /// ButtonWidget initialization
  ButtonWidget({
    this.style,
    required this.text,
    this.prefixIconSvgAssetPath,
    this.prefixIcon,
    this.suffixIconSvgAssetPath,
    this.suffixIcon,
    this.onTap,
    this.isLoading,
    String? tag,
    List<String>? tags,
  }) : loadingTags = [
          if (tag != null) tag,
          if (tags != null) ...tags,
        ];

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends AbstractStatefulWidgetState<ButtonWidget> with TickerProviderStateMixin {
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

    final screenDataState = ScreenDataState.of(context);

    final theIsLoading = widget.isLoading ?? screenDataState?.isLoading ?? false;

    if (widget.isLoading != oldWidget.isLoading) {
      if (theIsLoading) {
        _initLoadingAnimation(context);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _stopLoadingAnimation();
        });
      }
    }
  }

  /// Run initializations of widget on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    final theIsLoading = _isLoading(context);

    if (theIsLoading) {
      _initLoadingAnimation(context);
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool isDisabled = widget.onTap == null;

    final bool fullWidthMobileOnly = widget.style?.fullWidthMobileOnly ?? commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final theVariant = widget.style?.variant ?? commonTheme?.buttonsStyle.buttonStyle.variant ?? ButtonVariant.Outlined;

    Color color = widget.style?.color ?? commonTheme?.buttonsStyle.buttonStyle.color ?? Colors.black;
    if (isDisabled) {
      color = widget.style?.disabledColor ?? commonTheme?.buttonsStyle.buttonStyle.disabledColor ?? Colors.grey;
    }
    Color iconColor = widget.style?.iconColor ?? commonTheme?.buttonsStyle.buttonStyle.iconColor ?? color;
    if (isDisabled) {
      iconColor = widget.style?.disabledIconColor ?? commonTheme?.buttonsStyle.buttonStyle.disabledIconColor ?? color;
    }

    final theBorderWidth = widget.style?.borderWidth ?? commonTheme?.buttonsStyle.buttonStyle.borderWidth ?? 1;
    final BorderRadius? borderRadius = widget.style?.borderRadius ?? commonTheme?.buttonsStyle.buttonStyle.borderRadius;
    final boxShadow = widget.style?.boxShadow ?? commonTheme?.buttonsStyle.buttonStyle.boxShadow;

    late Widget inner;

    final theIsLoading = _isLoading(context);

    if (theIsLoading) {
      if (_animationController == null) {
        _initLoadingAnimation(context);
      }

      final loadingIconSvgAssetPath = widget.style?.loadingIconSvgAssetPath ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconSvgAssetPath;
      final loadingIcon = widget.style?.loadingIcon ?? commonTheme?.buttonsStyle.buttonStyle.loadingIcon;
      final loadingIconWidth = widget.style?.loadingIconWidth ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconWidth ?? kIconSize;
      final loadingIconHeight = widget.style?.loadingIconHeight ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconHeight ?? kIconSize;

      bool loadingIconRestricted = (widget.style?.loadingIconRestricted ?? commonTheme?.buttonsStyle.buttonStyle.loadingIconRestricted) ?? true;

      Widget? icon;
      if (loadingIcon != null) {
        if (loadingIconRestricted) {
          icon = Container(
            width: loadingIconWidth,
            height: loadingIconHeight,
            child: loadingIcon,
          );
        } else {
          icon = loadingIcon;
        }
      } else if (loadingIconSvgAssetPath != null) {
        if (loadingIconRestricted) {
          icon = SvgPicture.asset(
            loadingIconSvgAssetPath,
            width: loadingIconWidth,
            height: loadingIconHeight,
            color: iconColor,
          );
        } else {
          icon = SvgPicture.asset(
            loadingIconSvgAssetPath,
            color: iconColor,
          );
        }
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
      final suffixIconWidth = widget.style?.suffixIconWidth ?? commonTheme?.buttonsStyle.buttonStyle.suffixIconWidth ?? kIconSize;
      final suffixIconHeight = widget.style?.suffixIconHeight ?? commonTheme?.buttonsStyle.buttonStyle.suffixIconHeight ?? kIconSize;

      bool prefixIconRestricted = (widget.style?.prefixIconRestricted ?? commonTheme?.buttonsStyle.buttonStyle.prefixIconRestricted) ?? true;
      bool suffixIconRestricted = (widget.style?.suffixIconRestricted ?? commonTheme?.buttonsStyle.buttonStyle.suffixIconRestricted) ?? true;
      Widget? prefixIcon;
      Widget? suffixIcon;

      if (widget.prefixIcon != null) {
        if (prefixIconRestricted) {
          prefixIcon = Container(
            width: preffixIconWidth,
            height: preffixIconHeight,
            child: widget.prefixIcon,
          );
        } else {
          prefixIcon = widget.prefixIcon;
        }
      } else if (widget.prefixIconSvgAssetPath != null) {
        if (prefixIconRestricted) {
          prefixIcon = SvgPicture.asset(
            widget.prefixIconSvgAssetPath!,
            width: preffixIconWidth,
            height: preffixIconHeight,
            color: iconColor,
          );
        } else {
          prefixIcon = SvgPicture.asset(
            widget.prefixIconSvgAssetPath!,
            color: iconColor,
          );
        }
      }

      if (widget.suffixIcon != null) {
        if (suffixIconRestricted) {
          suffixIcon = Container(
            width: suffixIconWidth,
            height: suffixIconHeight,
            child: widget.suffixIcon,
          );
        } else {
          suffixIcon = widget.suffixIcon;
        }
      } else if (widget.suffixIconSvgAssetPath != null) {
        if (suffixIconRestricted) {
          suffixIcon = SvgPicture.asset(
            widget.suffixIconSvgAssetPath!,
            width: suffixIconWidth,
            height: suffixIconHeight,
            color: iconColor,
          );
        } else {
          suffixIcon = SvgPicture.asset(
            widget.suffixIconSvgAssetPath!,
            color: iconColor,
          );
        }
      }

      final prefixIconSpacing = widget.style?.prefixIconSpacing ?? commonTheme?.buttonsStyle.buttonStyle.prefixIconSpacing ?? kCommonHorizontalMargin;
      final suffixIconSpacing = widget.style?.suffixIconSpacing ?? commonTheme?.buttonsStyle.buttonStyle.suffixIconSpacing ?? kCommonHorizontalMargin;

      TextStyle? textStyle;
      if (isDisabled) {
        textStyle = widget.style?.disabledTextStyle ?? commonTheme?.buttonsStyle.buttonStyle.disabledTextStyle;
      } else if (theVariant == ButtonVariant.Filled) {
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
          Flexible(
            child: Text(
              widget.text,
              style: textStyle,
            ),
          ),
          if (suffixIcon != null) ...[
            Container(
              width: suffixIconSpacing,
            ),
            suffixIcon,
          ],
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
          alignment: widget.style?.alignment ?? commonTheme?.buttonsStyle.buttonStyle.alignment,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: theVariant == ButtonVariant.TextOnly ? Colors.transparent : color,
              width: theBorderWidth,
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

  /// Determine if screen loading state applies to this widget
  bool _isLoading(BuildContext context) {
    final screenDataState = ScreenDataState.of(context);

    bool isLoading = false;

    if (screenDataState == null ||
        (screenDataState.loadingTags.isEmpty && widget.loadingTags.isEmpty) ||
        (screenDataState.loadingTags.isNotEmpty && widget.loadingTags.any((tag) => screenDataState.loadingTags.contains(tag)))) {
      isLoading = widget.isLoading ?? screenDataState?.isLoading ?? false;
    }

    return isLoading;
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
    _animationController?.stop();

    _animationController?.dispose();

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
  final bool? fullWidthMobileOnly;
  final ButtonVariant variant;
  final TextStyle textStyle;
  final TextStyle filledTextStyle;
  final TextStyle disabledTextStyle;
  final bool widthWrapContent;
  final double width;
  final double height;
  final AlignmentGeometry? alignment;
  final EdgeInsets contentPadding;
  final bool prefixIconRestricted;
  final double preffixIconWidth;
  final double preffixIconHeight;
  final bool suffixIconRestricted;
  final double suffixIconWidth;
  final double suffixIconHeight;
  final Color? color;
  final Color? iconColor;
  final Color? disabledColor;
  final Color? disabledIconColor;
  final double prefixIconSpacing;
  final double suffixIconSpacing;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final String? loadingIconSvgAssetPath;
  final Widget? loadingIcon;
  final bool loadingIconRestricted;
  final double loadingIconWidth;
  final double loadingIconHeight;
  final Duration loadingAnimationDuration;

  /// CommonButtonStyle initialization
  const CommonButtonStyle({
    this.fullWidthMobileOnly,
    this.variant = ButtonVariant.Outlined,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.filledTextStyle = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    this.disabledTextStyle = const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
    this.widthWrapContent = false,
    this.width = double.infinity,
    this.height = kMinInteractiveSize,
    this.alignment,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: kCommonHorizontalMargin),
    this.prefixIconRestricted = true,
    this.preffixIconWidth = kIconSize,
    this.preffixIconHeight = kIconSize,
    this.suffixIconRestricted = true,
    this.suffixIconWidth = kIconSize,
    this.suffixIconHeight = kIconSize,
    this.color = Colors.black,
    this.iconColor,
    this.disabledColor = Colors.grey,
    this.disabledIconColor,
    this.prefixIconSpacing = kCommonHorizontalMargin,
    this.suffixIconSpacing = kCommonHorizontalMargin,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
    this.boxShadow,
    this.loadingIconSvgAssetPath,
    this.loadingIcon,
    this.loadingIconRestricted = true,
    this.loadingIconWidth = kIconSize,
    this.loadingIconHeight = kIconSize,
    this.loadingAnimationDuration = const Duration(milliseconds: 1200),
  });

  /// Create copy of this style with changes
  CommonButtonStyle copyWith({
    bool? fullWidthMobileOnly,
    ButtonVariant? variant,
    TextStyle? textStyle,
    TextStyle? filledTextStyle,
    TextStyle? disabledTextStyle,
    bool? widthWrapContent,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    EdgeInsets? contentPadding,
    bool? prefixIconRestricted,
    double? preffixIconWidth,
    double? preffixIconHeight,
    bool? suffixIconRestricted,
    double? suffixIconWidth,
    double? suffixIconHeight,
    Color? color,
    Color? iconColor,
    Color? disabledColor,
    Color? disabledIconColor,
    double? prefixIconSpacing,
    double? suffixIconSpacing,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    String? loadingIconSvgAssetPath,
    Widget? loadingIcon,
    bool? loadingIconRestricted,
    double? loadingIconWidth,
    double? loadingIconHeight,
    Duration? loadingAnimationDuration,
  }) {
    return CommonButtonStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      variant: variant ?? this.variant,
      textStyle: textStyle ?? this.textStyle,
      filledTextStyle: filledTextStyle ?? this.filledTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      widthWrapContent: widthWrapContent ?? this.widthWrapContent,
      width: width ?? this.width,
      height: height ?? this.height,
      alignment: alignment ?? this.alignment,
      contentPadding: contentPadding ?? this.contentPadding,
      prefixIconRestricted: prefixIconRestricted ?? this.prefixIconRestricted,
      preffixIconWidth: preffixIconWidth ?? this.preffixIconWidth,
      preffixIconHeight: preffixIconHeight ?? this.preffixIconHeight,
      suffixIconRestricted: suffixIconRestricted ?? this.suffixIconRestricted,
      suffixIconWidth: suffixIconWidth ?? this.suffixIconWidth,
      suffixIconHeight: suffixIconHeight ?? this.suffixIconHeight,
      color: color ?? this.color,
      iconColor: iconColor ?? this.iconColor,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      prefixIconSpacing: prefixIconSpacing ?? this.prefixIconSpacing,
      suffixIconSpacing: suffixIconSpacing ?? this.suffixIconSpacing,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      loadingIconSvgAssetPath: loadingIconSvgAssetPath ?? this.loadingIconSvgAssetPath,
      loadingIcon: loadingIcon ?? this.loadingIcon,
      loadingIconRestricted: loadingIconRestricted ?? this.loadingIconRestricted,
      loadingIconWidth: loadingIconWidth ?? this.loadingIconWidth,
      loadingIconHeight: loadingIconHeight ?? this.loadingIconHeight,
      loadingAnimationDuration: loadingAnimationDuration ?? this.loadingAnimationDuration,
    );
  }
}
