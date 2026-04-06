import 'package:flutter/material.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class CommonSpace extends StatelessWidget {
  /// CommonSpace initialization
  const CommonSpace({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      width: commonTheme?.commonDimens.horizontalMargin ?? kCommonHorizontalMargin,
      height: commonTheme?.commonDimens.verticalMargin ?? kCommonVerticalMargin,
    );
  }
}

class CommonSpaceH extends StatelessWidget {
  /// CommonSpaceH initialization
  const CommonSpaceH({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      width: commonTheme?.commonDimens.horizontalMargin ?? kCommonHorizontalMargin,
    );
  }
}

class CommonSpaceHDouble extends StatelessWidget {
  /// CommonSpaceHDouble initialization
  const CommonSpaceHDouble({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      width: commonTheme?.commonDimens.horizontalMarginDouble ?? kCommonHorizontalMarginDouble,
    );
  }
}

class CommonSpaceHHalf extends StatelessWidget {
  /// CommonSpaceHHalf initialization
  const CommonSpaceHHalf({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      width: commonTheme?.commonDimens.horizontalMarginHalf ?? kCommonHorizontalMarginHalf,
    );
  }
}

class CommonSpaceV extends StatelessWidget {
  /// CommonSpaceV initialization
  const CommonSpaceV({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      height: commonTheme?.commonDimens.verticalMargin ?? kCommonVerticalMargin,
    );
  }
}

class CommonSpaceVDouble extends StatelessWidget {
  /// CommonSpaceVDouble initialization
  const CommonSpaceVDouble({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      height: commonTheme?.commonDimens.verticalMarginDouble ?? kCommonVerticalMarginDouble,
    );
  }
}

class CommonSpaceVHalf extends StatelessWidget {
  /// CommonSpaceVHalf initialization
  const CommonSpaceVHalf({super.key});

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    return SizedBox(
      height: commonTheme?.commonDimens.verticalMarginHalf ?? kCommonVerticalMarginHalf,
    );
  }
}
