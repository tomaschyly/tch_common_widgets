import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonTheme extends InheritedWidget {
  final CommonDimens commonDimens;
  final String? fontFamily;
  final String? iOSFontFamily;
  final ButtonsStyle buttonsStyle;
  final DialogsStyle dialogsStyle;
  final FormStyle formStyle;
  final TooltipStyle tooltipStyle;

  /// CommonTheme initialization
  const CommonTheme({
    required Widget child,
    this.commonDimens = const CommonDimens(),
    this.fontFamily,
    this.iOSFontFamily,
    this.buttonsStyle = const ButtonsStyle(),
    this.dialogsStyle = const DialogsStyle(),
    this.formStyle = const FormStyle(),
    this.tooltipStyle = const TooltipStyle(),
  }) : super(child: child);

  /// Access current CommonTheme anywhere from BuildContext
  static T? of<T extends CommonTheme>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<T>();
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

  /// Check if OS Dark mode is enabled
  static bool isOSDarkMode(BuildContext context) => MediaQuery.of(context).platformBrightness == Brightness.dark;
}

/// Shorthand to get CommonTheme from context
CommonTheme getCommonTheme(BuildContext context) => CommonTheme.of<CommonTheme>(context)!;

extension CommonThemeExtension on BuildContext {
  /// Shorthand to get CommonTheme from context
  CommonTheme get commonTheme => CommonTheme.of<CommonTheme>(this)!;

  /// Shorthand to get nullable CommonTheme from context
  CommonTheme? get commonThemeOrNull => CommonTheme.of<CommonTheme>(this);
}
