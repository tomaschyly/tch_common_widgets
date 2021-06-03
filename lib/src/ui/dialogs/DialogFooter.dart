import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/ui/buttons/ButtonWidget.dart' as Common;
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class DialogFooter extends StatelessWidget {
  final DialogFooterStyle style;
  final String? noText;
  final String? yesText;
  final GestureTapCallback? noOnTap;
  final GestureTapCallback? yesOnTap;
  final bool yesIsDanger;

  /// DialogFooter initialization
  const DialogFooter({
    required this.style,
    required this.noText,
    required this.yesText,
    this.noOnTap,
    this.yesOnTap,
    this.yesIsDanger = false,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theNoText = noText;
    final theYesText = yesText;

    Common.ButtonStyle yesButtonStyle = style.buttonStyle.copyWith(
      variant: Common.ButtonVariant.Filled,
      color: yesIsDanger ? style.dangerColor : style.buttonStyle.color,
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: style.mainAxisAlignment,
      children: [
        if (theNoText != null)
          Common.ButtonWidget(
            style: style.buttonStyle,
            text: theNoText,
            onTap: noOnTap,
          ),
        if (theNoText != null && theYesText != null) CommonSpaceHHalf(),
        if (theYesText != null)
          Common.ButtonWidget(
            style: yesButtonStyle,
            text: theYesText,
            onTap: yesOnTap,
          ),
      ],
    );
  }
}

class DialogFooterStyle {
  final MainAxisAlignment mainAxisAlignment;
  final Common.ButtonStyle buttonStyle;
  final Color dangerColor;

  /// DialogFooterStyle initialization
  const DialogFooterStyle({
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.buttonStyle = const Common.ButtonStyle(
      widthWrapContent: true,
    ),
    this.dangerColor = Colors.red,
  });

  /// Create copy of this tyle with changes
  DialogFooterStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    Common.ButtonStyle? buttonStyle,
    Color? dangerColor,
  }) {
    return DialogFooterStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      dangerColor: dangerColor ?? this.dangerColor,
    );
  }
}
