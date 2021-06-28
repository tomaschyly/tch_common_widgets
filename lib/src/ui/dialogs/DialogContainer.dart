import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';

class DialogContainer extends StatelessWidget {
  final DialogContainerStyle style;
  final List<Widget> content;

  /// DialogContainer initialization
  const DialogContainer({
    required this.style,
    required this.content,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.dialogsStyle.fullWidthMobileOnly ?? true;

    final borderRadius = style.borderRadius;

    Widget dialog = Container(
      width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
      padding: style.dialogPadding,
      margin: style.dialogMargin,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: Border.all(
          color: style.color,
          width: 1,
        ),
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
    );

    if (borderRadius != null) {
      dialog = ClipRRect(
        borderRadius: borderRadius,
        child: dialog,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: style.mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: dialog,
        ),
      ],
    );
  }
}

class DialogContainerStyle {
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets dialogPadding;
  final EdgeInsets dialogMargin;
  final Color color;
  final Color backgroundColor;
  final BorderRadius? borderRadius;

  /// DialogContainerStyle initialization
  const DialogContainerStyle({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.dialogPadding = const EdgeInsets.all(12),
    this.dialogMargin = const EdgeInsets.all(kCommonPrimaryMargin),
    this.color = Colors.transparent,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
  });

  /// Create copy of this tyle with changes
  DialogContainerStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? dialogPadding,
    EdgeInsets? dialogMargin,
    Color? color,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return DialogContainerStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      dialogMargin: dialogMargin ?? this.dialogMargin,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
