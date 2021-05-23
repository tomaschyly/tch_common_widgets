import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonSpace extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      width: commonTheme.commonDimens.horizontalMargin,
      height: commonTheme.commonDimens.verticalMargin,
    );
  }
}

class CommonSpaceH extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      width: commonTheme.commonDimens.horizontalMargin,
    );
  }
}

class CommonSpaceHDouble extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      width: commonTheme.commonDimens.horizontalMarginDouble,
    );
  }
}

class CommonSpaceHHalf extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      width: commonTheme.commonDimens.horizontalMarginHalf,
    );
  }
}

class CommonSpaceV extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      height: commonTheme.commonDimens.verticalMargin,
    );
  }
}

class CommonSpaceVDouble extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      height: commonTheme.commonDimens.verticalMarginDouble,
    );
  }
}

class CommonSpaceVHalf extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    return Container(
      height: commonTheme.commonDimens.verticalMarginHalf,
    );
  }
}
