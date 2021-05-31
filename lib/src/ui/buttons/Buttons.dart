import 'package:tch_common_widgets/src/ui/buttons/IconButtonWidget.dart';

class ButtonsStyle {
  final IconButtonStyle iconButtonStyle;

  /// ButtonsStyle initialization
  const ButtonsStyle({
    this.iconButtonStyle = const IconButtonStyle(),
  });

  /// Create copy if this style with changes
  ButtonsStyle copyWith({
    IconButtonStyle? iconButtonStyle,
  }) {
    return ButtonsStyle(
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
    );
  }
}
