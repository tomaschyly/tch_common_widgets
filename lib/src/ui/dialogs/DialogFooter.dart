import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/ui/buttons/ButtonWidget.dart';
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class DialogFooter extends StatelessWidget {
  final DialogFooterStyle style;
  final String? noText;
  final String? yesText;
  final GestureTapCallback? noOnTap;
  final GestureTapCallback? yesOnTap;
  final bool yesIsDanger;
  final bool noIsLoading;
  final bool yesIsLoading;

  /// DialogFooter initialization
  const DialogFooter({
    required this.style,
    required this.noText,
    required this.yesText,
    this.noOnTap,
    this.yesOnTap,
    this.yesIsDanger = false,
    this.noIsLoading = false,
    this.yesIsLoading = false,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theNoText = noText;
    final theYesText = yesText;

    CommonButtonStyle yesButtonStyle = style.buttonStyle.copyWith(
      variant: ButtonVariant.Filled,
      color: yesIsDanger ? style.dangerColor : style.buttonStyle.color,
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: style.mainAxisAlignment,
      children: [
        if (theNoText != null)
          ButtonWidget(
            style: style.buttonStyle,
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
      ],
    );
  }
}

class DialogFooterStyle {
  final MainAxisAlignment mainAxisAlignment;
  final CommonButtonStyle buttonStyle;
  final Color dangerColor;

  /// DialogFooterStyle initialization
  const DialogFooterStyle({
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.buttonStyle = const CommonButtonStyle(
      widthWrapContent: true,
    ),
    this.dangerColor = Colors.red,
  });

  /// Create copy of this tyle with changes
  DialogFooterStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    CommonButtonStyle? buttonStyle,
    Color? dangerColor,
  }) {
    return DialogFooterStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      dangerColor: dangerColor ?? this.dangerColor,
    );
  }
}
