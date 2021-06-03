import 'package:flutter/material.dart';
import 'package:tch_common_widgets/src/ui/buttons/Buttons.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonTheme extends InheritedWidget {
  final CommonDimens commonDimens;
  final String? fontFamily;
  final ButtonsStyle buttonsStyle;
  final DialogsStyle dialogsStyle;
  final FormStyle formStyle;

  /// CommonTheme initialization
  const CommonTheme({
    required Widget child,
    this.commonDimens = const CommonDimens(),
    this.fontFamily,
    this.buttonsStyle = const ButtonsStyle(),
    this.dialogsStyle = const DialogsStyle(),
    this.formStyle = const FormStyle(),
  }) : super(child: child);

  /// Access current CommonTheme anywhere from BuildContext
  static CommonTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommonTheme>();
  }

  /// Disable update notifications
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  /// PreProcess TextStyle before apply to widgets, used e.g. for global fontFamily
  TextStyle preProcessTextStyle(TextStyle textStyle) {
    TextStyle processedTextStyle = textStyle;

    final theFontFamily = fontFamily;
    if (theFontFamily != null && processedTextStyle.fontFamily == null) {
      processedTextStyle = processedTextStyle.copyWith(fontFamily: theFontFamily);
    }

    return processedTextStyle;
  }
}
