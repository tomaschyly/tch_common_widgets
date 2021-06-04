import 'package:tch_common_widgets/src/ui/dialogs/ConfirmDialog.dart';
import 'package:tch_common_widgets/src/ui/dialogs/ListDialog.dart';

class DialogsStyle {
  final bool fullWidthMobileOnly;
  final ConfirmDialogStyle confirmDialogStyle;
  final ListDialogStyle listDialogStyle;

  /// DialogsStyle initialization
  const DialogsStyle({
    this.fullWidthMobileOnly = true,
    this.confirmDialogStyle = const ConfirmDialogStyle(),
    this.listDialogStyle = const ListDialogStyle(),
  });

  /// Create copy if this style with changes
  DialogsStyle copyWith({
    bool? fullWidthMobileOnly,
    ConfirmDialogStyle? confirmDialogStyle,
    ListDialogStyle? listDialogStyle,
  }) {
    return DialogsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      confirmDialogStyle: confirmDialogStyle ?? this.confirmDialogStyle,
      listDialogStyle: listDialogStyle ?? this.listDialogStyle,
    );
  }
}
