import 'package:tch_common_widgets/tch_common_widgets.dart';

class ButtonsStyle {
  final bool fullWidthMobileOnly;
  final bool ignoreInteractionsWhenLoading;
  final CommonButtonStyle buttonStyle;
  final IconButtonStyle iconButtonStyle;

  /// ButtonsStyle initialization
  const ButtonsStyle({
    this.fullWidthMobileOnly = true,
    this.ignoreInteractionsWhenLoading = true,
    this.buttonStyle = const CommonButtonStyle(),
    this.iconButtonStyle = const IconButtonStyle(),
  });

  /// Create copy of this style with changes
  ButtonsStyle copyWith({
    bool? fullWidthMobileOnly,
    CommonButtonStyle? buttonStyle,
    IconButtonStyle? iconButtonStyle,
  }) {
    return ButtonsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
    );
  }
}
