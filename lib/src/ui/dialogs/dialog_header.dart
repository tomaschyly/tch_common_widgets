import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class DialogHeader extends StatelessWidget {
  final DialogHeaderStyle style;
  final String title;
  final Widget? leading;
  final Widget? trailing;

  /// DialogHeader initialization
  const DialogHeader({
    required this.style,
    required this.title,
    this.leading,
    this.trailing,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = context.commonThemeOrNull;

    TextStyle textStyle = style.textStyle;
    if (commonTheme != null) {
      textStyle = commonTheme.preProcessTextStyle(textStyle);
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (leading != null) leading!,
        Expanded(
          child: Text(
            title,
            style: textStyle,
            textAlign: style.textAlign,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class DialogHeaderStyle {
  final TextStyle textStyle;
  final TextAlign textAlign;

  /// DialogHeaderStyle initialization
  const DialogHeaderStyle({
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 20),
    this.textAlign = TextAlign.start,
  });

  /// Create copy of this tyle with changes
  DialogHeaderStyle copyWith({
    TextStyle? textStyle,
    TextAlign? textAlign,
  }) {
    return DialogHeaderStyle(
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}
