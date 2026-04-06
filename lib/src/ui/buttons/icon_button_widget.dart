import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/widget.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class IconButtonWidget extends AbstractStatefulWidget {
  final IconButtonStyle? style;
  final String? svgAssetPath;
  final Widget? iconWidget;
  final GestureTapCallback? onTap;
  final bool? isLoading;
  final List<String> loadingTags;
  final String? tooltip;
  final bool? ignoreInteractionsWhenLoading;

  /// IconButtonWidget initialization
  IconButtonWidget({
    super.key,
    this.style,
    this.svgAssetPath,
    this.iconWidget,
    this.onTap,
    this.isLoading,
    String? tag,
    List<String>? tags,
    this.tooltip,
    this.ignoreInteractionsWhenLoading,
  }) : assert(svgAssetPath != null || iconWidget != null),
       loadingTags = [?tag, ...?tags];

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState
    extends AbstractStatefulWidgetState<IconButtonWidget>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool _isHovered = false;

  /// Manually dispose of resources
  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;

    super.dispose();
  }

  /// Widget parameters changed
  @override
  void didUpdateWidget(covariant IconButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final screenDataState = ScreenDataState.of(context);

    final theIsLoading =
        widget.isLoading ?? screenDataState?.isLoading ?? false;

    if (widget.isLoading != oldWidget.isLoading) {
      if (theIsLoading) {
        _initLoadingAnimation(context);
      } else {
        addPostFrameCallback((timeStamp) {
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

    final IconButtonVariant variant =
        (widget.style?.variant ??
            commonTheme?.buttonsStyle.iconButtonStyle.variant) ??
        .outlined;

    final width =
        (widget.style?.width ??
            commonTheme?.buttonsStyle.iconButtonStyle.width) ??
        kMinInteractiveSize;
    final height =
        (widget.style?.height ??
            commonTheme?.buttonsStyle.iconButtonStyle.height) ??
        kMinInteractiveSize;
    final iconWidth =
        (widget.style?.iconWidth ??
            commonTheme?.buttonsStyle.iconButtonStyle.iconWidth) ??
        kIconSize;
    final iconHeight =
        (widget.style?.iconHeight ??
            commonTheme?.buttonsStyle.iconButtonStyle.iconHeight) ??
        kIconSize;

    Color color =
        widget.style?.color ??
        commonTheme?.buttonsStyle.iconButtonStyle.color ??
        Colors.black;
    Color iconColor =
        widget.style?.iconColor ??
        commonTheme?.buttonsStyle.iconButtonStyle.iconColor ??
        color;

    bool iconRestricted =
        (widget.style?.iconRestricted ??
            commonTheme?.buttonsStyle.iconButtonStyle.iconRestricted) ??
        true;
    late Widget icon;

    final theIsLoading = _isLoading(context);
    final ignoreInteractionsWhenLoading =
        widget.ignoreInteractionsWhenLoading ??
        commonTheme?.buttonsStyle.ignoreInteractionsWhenLoading ??
        true;
    MouseCursor mouseCursor =
        widget.style?.mouseCursor ??
        commonTheme?.buttonsStyle.iconButtonStyle.mouseCursor ??
        SystemMouseCursors.click;
    final isInteractive =
        widget.onTap != null &&
        !(theIsLoading && ignoreInteractionsWhenLoading);
    final hoverStyle =
        widget.style?.hoverStyle ??
        commonTheme?.buttonsStyle.iconButtonStyle.hoverStyle;
    final isHoverActive = isInteractive && _isHovered;

    if (isHoverActive && hoverStyle != null) {
      color = hoverStyle.color ?? color;
      mouseCursor = hoverStyle.mouseCursor ?? mouseCursor;
      iconColor = hoverStyle.iconColor ?? iconColor;
    }

    if (theIsLoading) {
      if (_animationController == null) {
        _initLoadingAnimation(context);
      }

      final loadingIconSvgAssetPath =
          widget.style?.loadingIconSvgAssetPath ??
          commonTheme?.buttonsStyle.iconButtonStyle.loadingIconSvgAssetPath;
      final loadingIcon =
          widget.style?.loadingIcon ??
          commonTheme?.buttonsStyle.iconButtonStyle.loadingIcon;
      final loadingIconWidth =
          widget.style?.loadingIconWidth ??
          commonTheme?.buttonsStyle.iconButtonStyle.loadingIconWidth ??
          kIconSize;
      final loadingIconHeight =
          widget.style?.loadingIconHeight ??
          commonTheme?.buttonsStyle.iconButtonStyle.loadingIconHeight ??
          kIconSize;

      bool loadingIconRestricted =
          (widget.style?.loadingIconRestricted ??
              commonTheme
                  ?.buttonsStyle
                  .iconButtonStyle
                  .loadingIconRestricted) ??
          true;

      Widget? loadingIconWidget;
      if (loadingIcon != null) {
        if (loadingIconRestricted) {
          loadingIconWidget = SizedBox(
            width: loadingIconWidth,
            height: loadingIconHeight,
            child: loadingIcon,
          );
        } else {
          loadingIconWidget = loadingIcon;
        }
      } else if (loadingIconSvgAssetPath != null) {
        if (loadingIconRestricted) {
          loadingIconWidget = SvgPicture.asset(
            loadingIconSvgAssetPath,
            width: loadingIconWidth,
            height: loadingIconHeight,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
        } else {
          loadingIconWidget = SvgPicture.asset(
            loadingIconSvgAssetPath,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
        }
      }

      icon = AnimatedBuilder(
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
              child: SizedBox(
                width: loadingIconWidth,
                height: loadingIconHeight,
                child: CircularProgressIndicator(color: iconColor, value: 0.25),
              ),
            );
          }
        },
        child: loadingIconWidget,
      );
    } else {
      if (widget.iconWidget != null) {
        if (iconRestricted) {
          icon = SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: widget.iconWidget,
          );
        } else {
          icon = widget.iconWidget!;
        }
      } else {
        if (iconRestricted) {
          icon = SvgPicture.asset(
            widget.svgAssetPath!,
            width: iconWidth,
            height: iconHeight,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
        } else {
          icon = SvgPicture.asset(
            widget.svgAssetPath!,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
        }
      }
    }

    double theBorderWidth =
        widget.style?.borderWidth ??
        commonTheme?.buttonsStyle.iconButtonStyle.borderWidth ??
        1;
    BorderRadius? borderRadius =
        widget.style?.borderRadius ??
        commonTheme?.buttonsStyle.iconButtonStyle.borderRadius;
    List<BoxShadow>? boxShadow =
        widget.style?.boxShadow ??
        commonTheme?.buttonsStyle.iconButtonStyle.boxShadow;

    if (isHoverActive && hoverStyle != null) {
      theBorderWidth = hoverStyle.borderWidth ?? theBorderWidth;
      borderRadius = hoverStyle.borderRadius ?? borderRadius;
      boxShadow = hoverStyle.boxShadow ?? boxShadow;
    }

    Widget content = IgnorePointer(
      ignoring: theIsLoading && ignoreInteractionsWhenLoading,
      child: Material(
        color: variant == IconButtonVariant.filled ? color : Colors.transparent,
        child: InkWell(
          onTap: isInteractive ? widget.onTap : null,
          onHover: (isHovered) {
            _setHoverState(isInteractive ? isHovered : false);
          },
          mouseCursor: isInteractive ? mouseCursor : SystemMouseCursors.basic,
          child: Container(
            width: width,
            height: height,
            decoration: variant == IconButtonVariant.iconOnly
                ? null
                : BoxDecoration(
                    color: variant == IconButtonVariant.filled
                        ? color
                        : Colors.transparent,
                    border: Border.all(color: color, width: theBorderWidth),
                    borderRadius: borderRadius,
                    boxShadow: boxShadow,
                  ),
            child: Center(child: icon),
          ),
        ),
      ),
    );

    if (borderRadius != null) {
      content = ClipRRect(borderRadius: borderRadius, child: content);
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

    final bool canBeStretched =
        widget.style?.canBeStretched ??
        commonTheme?.buttonsStyle.iconButtonStyle.canBeStretched ??
        false;
    if (!canBeStretched) {
      content = SizedBox(
        width: width,
        height: height,
        child: Center(child: content),
      );
    }

    if (widget.tooltip != null) {
      content = TooltipWidget(message: widget.tooltip!, child: content);
    }

    return content;
  }

  /// Determine if screen loading state applies to this widget
  bool _isLoading(BuildContext context) {
    final screenDataState = ScreenDataState.of(context);

    bool isLoading = false;

    if (screenDataState == null ||
        (screenDataState.loadingTags.isEmpty && widget.loadingTags.isEmpty) ||
        (screenDataState.loadingTags.isNotEmpty &&
            widget.loadingTags.any(
              (tag) => screenDataState.loadingTags.contains(tag),
            ))) {
      isLoading = widget.isLoading ?? screenDataState?.isLoading ?? false;
    }

    return isLoading;
  }

  /// Initialize loading animation and start repeating
  void _initLoadingAnimation(BuildContext context) {
    final loadingAnimationDuration =
        widget.style?.loadingAnimationDuration ??
        CommonTheme.of(
          context,
        )?.buttonsStyle.iconButtonStyle.loadingAnimationDuration ??
        Duration(milliseconds: 1200);

    final resumeValue = _animationController?.value ?? 0.0;

    _animationController = AnimationController(
      vsync: this,
      duration: loadingAnimationDuration,
    );

    _animationController!.value = resumeValue;

    _animationController!.repeat();
  }

  /// Stop loading animation from running
  void _stopLoadingAnimation() {
    _animationController?.stop();

    _animationController?.dispose();

    _animationController = null;
  }

  /// Update hover state and rebuild only when value changes
  void _setHoverState(bool isHovered) {
    if (_isHovered == isHovered) {
      return;
    }

    setStateNotDisposed(() {
      _isHovered = isHovered;
    });
  }
}

enum IconButtonVariant { none, outlined, filled, iconOnly }

class IconButtonHoverStyle {
  final Color? color;
  final MouseCursor? mouseCursor;
  final Color? iconColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  /// IconButtonHoverStyle initialization
  const IconButtonHoverStyle({
    this.color,
    this.mouseCursor,
    this.iconColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
  });

  /// Create copy of this hover style with changes
  IconButtonHoverStyle copyWith({
    Color? color,
    MouseCursor? mouseCursor,
    Color? iconColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return IconButtonHoverStyle(
      color: color ?? this.color,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      iconColor: iconColor ?? this.iconColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }
}

class IconButtonStyle {
  final IconButtonVariant variant;
  final double width;
  final double height;
  final bool iconRestricted;
  final double iconWidth;
  final double iconHeight;
  final Color? color;
  final IconButtonHoverStyle? hoverStyle;
  final MouseCursor mouseCursor;
  final Color? iconColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool? canBeStretched;
  final String? loadingIconSvgAssetPath;
  final Widget? loadingIcon;
  final bool loadingIconRestricted;
  final double loadingIconWidth;
  final double loadingIconHeight;
  final Duration loadingAnimationDuration;

  /// IconButtonStyle initialization
  const IconButtonStyle({
    this.variant = .outlined,
    this.width = kMinInteractiveSize,
    this.height = kMinInteractiveSize,
    this.iconRestricted = true,
    this.iconWidth = kIconSize,
    this.iconHeight = kIconSize,
    this.color = Colors.black,
    this.hoverStyle,
    this.mouseCursor = SystemMouseCursors.click,
    this.iconColor,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(.circular(8)),
    this.boxShadow,
    this.canBeStretched,
    this.loadingIconSvgAssetPath,
    this.loadingIcon,
    this.loadingIconRestricted = true,
    this.loadingIconWidth = kIconSize,
    this.loadingIconHeight = kIconSize,
    this.loadingAnimationDuration = const Duration(milliseconds: 1200),
  });

  /// Create copy if this style with changes
  IconButtonStyle copyWith({
    IconButtonVariant? variant,
    double? width,
    double? height,
    bool? iconRestricted,
    double? iconWidth,
    double? iconHeight,
    Color? color,
    IconButtonHoverStyle? hoverStyle,
    MouseCursor? mouseCursor,
    Color? iconColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    bool? canBeStretched,
    String? loadingIconSvgAssetPath,
    Widget? loadingIcon,
    bool? loadingIconRestricted,
    double? loadingIconWidth,
    double? loadingIconHeight,
    Duration? loadingAnimationDuration,
  }) {
    return IconButtonStyle(
      variant: variant ?? this.variant,
      width: width ?? this.width,
      height: height ?? this.height,
      iconRestricted: iconRestricted ?? this.iconRestricted,
      iconWidth: iconWidth ?? this.iconWidth,
      iconHeight: iconHeight ?? this.iconHeight,
      color: color ?? this.color,
      hoverStyle: hoverStyle ?? this.hoverStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      iconColor: iconColor ?? this.iconColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      canBeStretched: canBeStretched ?? this.canBeStretched,
      loadingIconSvgAssetPath:
          loadingIconSvgAssetPath ?? this.loadingIconSvgAssetPath,
      loadingIcon: loadingIcon ?? this.loadingIcon,
      loadingIconRestricted:
          loadingIconRestricted ?? this.loadingIconRestricted,
      loadingIconWidth: loadingIconWidth ?? this.loadingIconWidth,
      loadingIconHeight: loadingIconHeight ?? this.loadingIconHeight,
      loadingAnimationDuration:
          loadingAnimationDuration ?? this.loadingAnimationDuration,
    );
  }
}
