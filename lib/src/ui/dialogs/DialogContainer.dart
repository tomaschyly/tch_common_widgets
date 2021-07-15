import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/dialogs/DialogFooter.dart';

class DialogContainer extends StatelessWidget {
  final DialogContainerStyle style;
  final bool isScrollable;
  final List<Widget>? contentBeforeScroll;
  final List<Widget> content;
  final DialogFooter dialogFooter;

  /// DialogContainer initialization
  const DialogContainer({
    required this.style,
    this.isScrollable = true,
    this.contentBeforeScroll,
    required this.content,
    required this.dialogFooter,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.dialogsStyle.fullWidthMobileOnly ?? true;

    final borderRadius = style.borderRadius;

    final theContentBeforeScroll = contentBeforeScroll;

    Widget dialog;

    if (isScrollable) {
      dialog = Container(
        width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
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
          children: [
            if (theContentBeforeScroll != null)
              Container(
                padding: style.dialogPadding.copyWith(
                  bottom: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: theContentBeforeScroll,
                ),
              ),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    padding: style.dialogPadding.copyWith(
                      top: theContentBeforeScroll != null ? 0 : null,
                      bottom: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: content,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: style.dialogPadding.copyWith(
                top: 0,
              ),
              child: dialogFooter,
            ),
          ],
        ),
      );
    } else {
      dialog = Container(
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
          children: [
            if (theContentBeforeScroll != null) ...theContentBeforeScroll,
            ...content,
            dialogFooter,
          ],
        ),
      );
    }

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
