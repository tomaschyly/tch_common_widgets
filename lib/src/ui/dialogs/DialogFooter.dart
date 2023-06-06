import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/ui/buttons/ButtonWidget.dart';
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class DialogFooter extends StatelessWidget {
  final DialogFooterStyle style;
  final String? noText;
  final String? yesText;
  final String? otherText;
  final GestureTapCallback? noOnTap;
  final GestureTapCallback? yesOnTap;
  final GestureTapCallback? otherOnTap;
  final bool yesIsDanger;
  final bool noIsLoading;
  final bool yesIsLoading;
  final bool otherIsLoading;
  final List<Widget> otherWidgets;

  /// DialogFooter initialization
  const DialogFooter({
    required this.style,
    required this.noText,
    required this.yesText,
    this.otherText,
    this.noOnTap,
    this.yesOnTap,
    this.otherOnTap,
    this.yesIsDanger = false,
    this.noIsLoading = false,
    this.yesIsLoading = false,
    this.otherIsLoading = false,
    this.otherWidgets = const [],
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theNoText = noText;
    final theYesText = yesText;
    final theOtherText = otherText;

    CommonButtonStyle yesButtonStyle = style.yesButtonStyle ??
        style.buttonStyle.copyWith(
          variant: ButtonVariant.Filled,
          color: yesIsDanger ? style.dangerColor : style.buttonStyle.color,
        );
    CommonButtonStyle noButtonStyle = style.noButtonStyle ?? style.buttonStyle;

    CommonButtonStyle otherButtonStyle = style.otherButtonStyle ?? style.buttonStyle;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: style.mainAxisAlignment,
      children: [
        ...otherWidgets,
        if (theOtherText != null && style.mainAxisAlignment != MainAxisAlignment.start) ...[
          ButtonWidget(
            style: otherButtonStyle,
            text: theOtherText,
            onTap: otherOnTap,
            isLoading: otherIsLoading,
          ),
          if (theNoText != null || theYesText != null) CommonSpaceHHalf(),
          Spacer(),
        ],
        if (theNoText != null)
          ButtonWidget(
            style: noButtonStyle,
            text: theNoText,
            onTap: noOnTap,
            isLoading: noIsLoading,
          ),
        if (theNoText != null && theYesText != null) CommonSpaceHHalf(),
        if (theYesText != null)
          ButtonWidget(
            style: yesButtonStyle,
            text: theYesText,
            onTap: yesOnTap,
            isLoading: yesIsLoading,
          ),
        if (theOtherText != null && style.mainAxisAlignment == MainAxisAlignment.start) ...[
          Spacer(),
          if (theNoText != null || theYesText != null) CommonSpaceHHalf(),
          ButtonWidget(
            style: otherButtonStyle,
            text: theOtherText,
            onTap: otherOnTap,
            isLoading: otherIsLoading,
          ),
        ],
      ],
    );
  }
}

class DialogFooterStyle {
  final MainAxisAlignment mainAxisAlignment;
  final CommonButtonStyle buttonStyle;
  final CommonButtonStyle? yesButtonStyle;
  final CommonButtonStyle? noButtonStyle;
  final CommonButtonStyle? otherButtonStyle;
  final Color dangerColor;

  /// DialogFooterStyle initialization
  const DialogFooterStyle({
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.buttonStyle = const CommonButtonStyle(
      widthWrapContent: true,
    ),
    this.yesButtonStyle,
    this.noButtonStyle,
    this.otherButtonStyle,
    this.dangerColor = Colors.red,
  });

  /// Create copy of this tyle with changes
  DialogFooterStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    CommonButtonStyle? buttonStyle,
    CommonButtonStyle? yesButtonStyle,
    CommonButtonStyle? noButtonStyle,
    CommonButtonStyle? otherButtonStyle,
    Color? dangerColor,
  }) {
    return DialogFooterStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      yesButtonStyle: yesButtonStyle ?? this.yesButtonStyle,
      noButtonStyle: noButtonStyle ?? this.noButtonStyle,
      otherButtonStyle: otherButtonStyle ?? this.otherButtonStyle,
      dangerColor: dangerColor ?? this.dangerColor,
    );
  }
}
