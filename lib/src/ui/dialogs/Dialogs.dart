import 'package:tch_common_widgets/src/ui/dialogs/ConfirmDialog.dart';
import 'package:tch_common_widgets/src/ui/dialogs/ListDialog.dart';

class DialogsStyle {
  final bool fullWidthMobileOnly;
  final double? dialogWidth;
  final ConfirmDialogStyle confirmDialogStyle;
  final ListDialogStyle listDialogStyle;

  /// DialogsStyle initialization
  const DialogsStyle({
    this.fullWidthMobileOnly = true,
    this.dialogWidth,
    this.confirmDialogStyle = const ConfirmDialogStyle(),
    this.listDialogStyle = const ListDialogStyle(),
  });

  /// Create copy if this style with changes
  DialogsStyle copyWith({
    bool? fullWidthMobileOnly,
    double? dialogWidth,
    ConfirmDialogStyle? confirmDialogStyle,
    ListDialogStyle? listDialogStyle,
  }) {
    return DialogsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      confirmDialogStyle: confirmDialogStyle ?? this.confirmDialogStyle,
      listDialogStyle: listDialogStyle ?? this.listDialogStyle,
    );
  }
}
