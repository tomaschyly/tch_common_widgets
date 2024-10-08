import 'package:tch_common_widgets/tch_common_widgets.dart';

class DialogsStyle {
  final bool fullWidthMobileOnly;
  final double? dialogWidth;
  final double? dialogHeight;
  final bool stretchContent;
  final GenericDialogStyle genericDialogStyle;
  final ConfirmDialogStyle confirmDialogStyle;
  final ListDialogStyle listDialogStyle;

  /// DialogsStyle initialization
  const DialogsStyle({
    this.fullWidthMobileOnly = true,
    this.dialogWidth,
    this.dialogHeight,
    this.stretchContent = false,
    this.genericDialogStyle = const GenericDialogStyle(),
    this.confirmDialogStyle = const ConfirmDialogStyle(),
    this.listDialogStyle = const ListDialogStyle(),
  });

  /// Create copy if this style with changes
  DialogsStyle copyWith({
    bool? fullWidthMobileOnly,
    double? dialogWidth,
    double? dialogHeight,
    bool? stretchContent,
    GenericDialogStyle? genericDialogStyle,
    ConfirmDialogStyle? confirmDialogStyle,
    ListDialogStyle? listDialogStyle,
  }) {
    return DialogsStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      dialogHeight: dialogHeight ?? this.dialogHeight,
      stretchContent: stretchContent ?? this.stretchContent,
      genericDialogStyle: genericDialogStyle ?? this.genericDialogStyle,
      confirmDialogStyle: confirmDialogStyle ?? this.confirmDialogStyle,
      listDialogStyle: listDialogStyle ?? this.listDialogStyle,
    );
  }
}

class GenericDialogStyle {
  final DialogContainerStyle dialogContainerStyle;
  final DialogHeaderStyle dialogHeaderStyle;
  final DialogFooterStyle dialogFooterStyle;

  /// GenericDialogStyle initialization
  const GenericDialogStyle({
    this.dialogContainerStyle = const DialogContainerStyle(),
    this.dialogHeaderStyle = const DialogHeaderStyle(),
    this.dialogFooterStyle = const DialogFooterStyle(),
  });

  /// Create copy of this tyle with changes
  GenericDialogStyle copyWith({
    DialogContainerStyle? dialogContainerStyle,
    DialogHeaderStyle? dialogHeaderStyle,
    DialogFooterStyle? dialogFooterStyle,
  }) {
    return GenericDialogStyle(
      dialogContainerStyle: dialogContainerStyle ?? this.dialogContainerStyle,
      dialogHeaderStyle: dialogHeaderStyle ?? this.dialogHeaderStyle,
      dialogFooterStyle: dialogFooterStyle ?? this.dialogFooterStyle,
    );
  }
}
