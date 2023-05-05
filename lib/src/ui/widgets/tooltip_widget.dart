import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';

class TooltipWidget extends StatelessWidget {
  final String? message;
  final InlineSpan? richMessage;
  final Widget child;
  final TooltipStyle? style;

  /// TooltipWidget initialization
  TooltipWidget({
    this.message,
    this.richMessage,
    required this.child,
    this.style,
  }) : assert((message == null) != (richMessage == null),
            'Either `message` or `richMessage` must be specified');

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final padding = style?.padding ??
        commonTheme?.tooltipStyle.padding ??
        const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
    final margin = style?.margin ?? commonTheme?.tooltipStyle.margin ?? null;
    final verticalOffset = style?.verticalOffset ??
        commonTheme?.tooltipStyle.verticalOffset ??
        null;
    final preferBelow =
        style?.preferBelow ?? commonTheme?.tooltipStyle.preferBelow ?? true;
    final decoration = style?.decoration ??
        commonTheme?.tooltipStyle.decoration ??
        BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        );
    final textStyle = style?.textStyle ??
        commonTheme?.tooltipStyle.textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 14,
        );
    final textAlign = style?.textAlign ??
        commonTheme?.tooltipStyle.textAlign ??
        TextAlign.center;

    return Tooltip(
      message: message,
      child: child,
      padding: padding,
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      decoration: decoration,
      textStyle: textStyle,
      textAlign: textAlign,
    );
  }
}

class TooltipStyle {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool? preferBelow;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  /// TooltipStyle initialization
  const TooltipStyle({
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.decoration,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 14),
    this.textAlign,
  });

  /// Create copy if this style with changes
  TooltipStyle copyWith({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? verticalOffset,
    bool? preferBelow,
    Decoration? decoration,
    TextStyle? textStyle,
    TextAlign? textAlign,
  }) =>
      TooltipStyle(
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
        verticalOffset: verticalOffset ?? this.verticalOffset,
        preferBelow: preferBelow ?? this.preferBelow,
        decoration: decoration ?? this.decoration,
        textStyle: textStyle ?? this.textStyle,
        textAlign: textAlign ?? this.textAlign,
      );
}
