import 'package:tch_common_widgets/src/ui/buttons/ButtonWidget.dart';
import 'package:tch_common_widgets/src/ui/buttons/IconButtonWidget.dart';

class ButtonsStyle {
  final bool fullWidthMobileOnly;
  final ButtonStyle buttonStyle;
  final IconButtonStyle iconButtonStyle;

  /// ButtonsStyle initialization
  const ButtonsStyle({
    this.fullWidthMobileOnly = true,
    this.buttonStyle = const ButtonStyle(),
    this.iconButtonStyle = const IconButtonStyle(),
  });

  /// Create copy if this style with changes
  ButtonsStyle copyWith({
    bool? fullWidthMobileOnly,
    ButtonStyle? buttonStyle,
    IconButtonStyle? iconButtonStyle,
  }) {
    return ButtonsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
    );
  }
}
