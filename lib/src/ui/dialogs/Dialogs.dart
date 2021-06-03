import 'package:tch_common_widgets/src/ui/dialogs/ConfirmDialog.dart';

class DialogsStyle {
  final bool fullWidthMobileOnly;
  final ConfirmDialogStyle confirmDialogStyle;

  /// DialogsStyle initialization
  const DialogsStyle({
    this.fullWidthMobileOnly = true,
    this.confirmDialogStyle = const ConfirmDialogStyle(),
  });

  /// Create copy if this style with changes
  DialogsStyle copyWith({
    bool? fullWidthMobileOnly,
    ConfirmDialogStyle? confirmDialogStyle,
  }) {
    return DialogsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      confirmDialogStyle: confirmDialogStyle ?? this.confirmDialogStyle,
    );
  }
}
