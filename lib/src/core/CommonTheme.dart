import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonTheme extends InheritedWidget {
  final CommonDimens commonDimens;

  /// CommonTheme initialization
  CommonTheme({
    required Widget child,
    this.commonDimens = const CommonDimens(),
  }) : super(child: child);

  /// Access current CommonTheme anywhere from BuildContext
  static CommonTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommonTheme>();
  }

  /// Disable update notifications
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
