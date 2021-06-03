import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/dialogs/DialogFooter.dart';
import 'package:tch_common_widgets/src/ui/dialogs/DialogHeader.dart';
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class ConfirmDialog extends StatelessWidget {
  final ConfirmDialogStyle? style;
  final String? title;
  final String? text;
  final String? noText;
  final String? yesText;
  final bool isDanger;

  /// ConfirmDialog initialization
  ConfirmDialog({
    this.style,
    this.title,
    this.text,
    this.noText,
    this.yesText,
    this.isDanger = false,
  });

  /// Show the dialog as a popup
  static Future<bool?> show(
    BuildContext context, {
    ConfirmDialogStyle? style,
    String? title,
    String? text,
    String? noText,
    String? yesText,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ConfirmDialog(
            style: style,
            title: title,
            text: text,
            noText: noText,
            yesText: yesText,
            isDanger: isDanger,
          ),
        );
      },
    );
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.dialogsStyle.fullWidthMobileOnly ?? true;

    final mainAxisAlignment = style?.mainAxisAlignment ?? commonTheme?.dialogsStyle.confirmDialogStyle.mainAxisAlignment ?? MainAxisAlignment.start;
    final dialogPadding = style?.dialogPadding ?? commonTheme?.dialogsStyle.confirmDialogStyle.dialogPadding ?? const EdgeInsets.all(12);
    final dialogMargin = style?.dialogMargin ?? commonTheme?.dialogsStyle.confirmDialogStyle.dialogMargin ?? const EdgeInsets.all(kCommonPrimaryMargin);

    final color = style?.color ?? commonTheme?.dialogsStyle.confirmDialogStyle.color ?? Colors.transparent;
    final backgroundColor = style?.backgroundColor ?? commonTheme?.dialogsStyle.confirmDialogStyle.backgroundColor ?? Colors.white;
    final borderRadius = style?.borderRadius ?? commonTheme?.dialogsStyle.confirmDialogStyle.borderRadius;

    final dialogHeaderStyle = style?.dialogHeaderStyle ?? commonTheme?.dialogsStyle.confirmDialogStyle.dialogHeaderStyle ?? const DialogHeaderStyle();
    final dialogFooterStyle = style?.dialogFooterStyle ?? commonTheme?.dialogsStyle.confirmDialogStyle.dialogFooterStyle ?? const DialogFooterStyle();

    final theText = text;
    TextStyle? textStyle = style?.textStyle ?? commonTheme?.dialogsStyle.confirmDialogStyle.textStyle;
    if (textStyle != null && commonTheme != null) {
      textStyle = commonTheme.preProcessTextStyle(textStyle);
    }

    Widget dialog = Container(
      width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
      padding: dialogPadding,
      margin: dialogMargin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: color,
          width: 1,
        ),
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DialogHeader(
            style: dialogHeaderStyle,
            title: title ?? 'Confirm Action',
          ),
          CommonSpaceVHalf(),
          if (theText != null) ...[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    theText,
                    style: textStyle,
                  ),
                ),
              ],
            ),
            CommonSpaceVHalf(),
          ],
          DialogFooter(
            style: dialogFooterStyle,
            noText: noText ?? 'No',
            yesText: yesText ?? 'Yes',
            noOnTap: () {
              Navigator.pop(context, false);
            },
            yesOnTap: () {
              Navigator.pop(context, true);
            },
            yesIsDanger: isDanger,
          ),
        ],
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
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: dialog,
        ),
      ],
    );
  }
}

class ConfirmDialogStyle {
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets dialogPadding;
  final EdgeInsets dialogMargin;
  final Color color;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle textStyle;
  final DialogHeaderStyle dialogHeaderStyle;
  final DialogFooterStyle dialogFooterStyle;

  /// ConfirmDialogStyle initialization
  const ConfirmDialogStyle({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.dialogPadding = const EdgeInsets.all(12),
    this.dialogMargin = const EdgeInsets.all(kCommonPrimaryMargin),
    this.color = Colors.transparent,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.dialogHeaderStyle = const DialogHeaderStyle(),
    this.dialogFooterStyle = const DialogFooterStyle(),
  });

  /// Create copy of this tyle with changes
  ConfirmDialogStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? dialogPadding,
    EdgeInsets? dialogMargin,
    Color? color,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    DialogHeaderStyle? dialogHeaderStyle,
    DialogFooterStyle? dialogFooterStyle,
  }) {
    return ConfirmDialogStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      dialogMargin: dialogMargin ?? this.dialogMargin,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      dialogHeaderStyle: dialogHeaderStyle ?? this.dialogHeaderStyle,
      dialogFooterStyle: dialogFooterStyle ?? this.dialogFooterStyle,
    );
  }
}
