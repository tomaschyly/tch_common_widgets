import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonSpace extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      width: commonTheme?.commonDimens.horizontalMargin ?? kCommonHorizontalMargin,
      height: commonTheme?.commonDimens.verticalMargin ?? kCommonVerticalMargin,
    );
  }
}

class CommonSpaceH extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      width: commonTheme?.commonDimens.horizontalMargin ?? kCommonHorizontalMargin,
    );
  }
}

class CommonSpaceHDouble extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      width: commonTheme?.commonDimens.horizontalMarginDouble ?? kCommonHorizontalMarginDouble,
    );
  }
}

class CommonSpaceHHalf extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      width: commonTheme?.commonDimens.horizontalMarginHalf ?? kCommonHorizontalMarginHalf,
    );
  }
}

class CommonSpaceV extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      height: commonTheme?.commonDimens.verticalMargin ?? kCommonVerticalMargin,
    );
  }
}

class CommonSpaceVDouble extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      height: commonTheme?.commonDimens.verticalMarginDouble ?? kCommonVerticalMarginDouble,
    );
  }
}

class CommonSpaceVHalf extends StatelessWidget {
  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return Container(
      height: commonTheme?.commonDimens.verticalMarginHalf ?? kCommonVerticalMarginHalf,
    );
  }
}
