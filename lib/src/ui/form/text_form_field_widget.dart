import 'package:flutter/services.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/color.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class TextFormFieldWidget extends AbstractStatefulWidget {
  final TextFormFieldStyle? style;
  final String? iOSFontFamily;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  // final ValueChanged<String>? onChanged; //TODO needs to also support iOS native views
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? label;
  final Widget? prefix;
  final Widget? prefixIcon;
  final bool prefixOnlyWhenNotEmpty;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool suffixOnlyWhenNotEmpty;
  final int lines;
  final int? maxLength;
  final List<FormFieldValidation<String>>? validations;
  final bool enabled;
  final bool autocorrect;
  final bool? obscureText;

  /// TextFormFieldWidget initialization
  TextFormFieldWidget({
    this.style,
    this.iOSFontFamily,
    Key? key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    // this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.label,
    this.prefix,
    this.prefixIcon,
    this.prefixOnlyWhenNotEmpty = false,
    this.suffix,
    this.suffixIcon,
    this.suffixOnlyWhenNotEmpty = false,
    this.lines = 1,
    this.maxLength,
    this.validations,
    this.enabled = true,
    this.autocorrect = true,
    this.obscureText,
  })  : assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends AbstractStatefulWidgetState<TextFormFieldWidget> {
  final _wrapperKey = GlobalKey();
  late FocusNode _focusNode;
  bool _isError = false;
  final _displayPrefix = ValueNotifier<bool>(true);
  final _displaySuffix = ValueNotifier<bool>(true);

  /// State initialization
  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.prefixOnlyWhenNotEmpty && widget.controller.text.isEmpty) {
      _displayPrefix.value = false;
    }

    if (widget.suffixOnlyWhenNotEmpty && widget.controller.text.isEmpty) {
      _displaySuffix.value = false;
    }
  }

  /// Manually dispose of resources
  @override
  void dispose() {
    widget.controller.removeListener(_controllerTextChanged);

    super.dispose();
  }

  /// Run initializations of screen on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    widget.controller.addListener(_controllerTextChanged);
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final TextFormFieldVariant theVariant = widget.style?.variant ?? commonTheme?.formStyle.textFormFieldStyle.variant ?? TextFormFieldVariant.Material;

    final bool animatedSizeChanges = commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly = widget.style?.fullWidthMobileOnly ?? commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    InputDecoration theDecoration = widget.style?.inputDecoration ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration ?? InputDecoration();

    if ((widget.style?.inputDecoration ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration) != null) {
      theDecoration = theDecoration.copyWith(
        enabledBorder: theDecoration.enabledBorder?.copyWith(
          borderSide: theDecoration.enabledBorder!.borderSide.copyWith(
            color: widget.style?.borderColor ?? commonTheme?.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        disabledBorder: theDecoration.disabledBorder?.copyWith(
          borderSide: theDecoration.disabledBorder!.borderSide.copyWith(
            color: widget.style?.disabledBorderColor ?? commonTheme?.formStyle.textFormFieldStyle.disabledBorderColor,
          ),
        ),
        focusedBorder: theDecoration.focusedBorder?.copyWith(
          borderSide: theDecoration.focusedBorder!.borderSide.copyWith(
            color: widget.style?.focusedBorderColor ?? commonTheme?.formStyle.textFormFieldStyle.focusedBorderColor,
          ),
        ),
        errorBorder: theDecoration.errorBorder?.copyWith(
          borderSide: theDecoration.errorBorder!.borderSide.copyWith(
            color: widget.style?.errorColor ?? commonTheme?.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        focusedErrorBorder: theDecoration.focusedErrorBorder?.copyWith(
          borderSide: theDecoration.focusedErrorBorder!.borderSide.copyWith(
            color: widget.style?.errorColor ?? commonTheme?.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        errorStyle: theDecoration.errorStyle?.copyWith(
          color: widget.style?.errorColor ?? commonTheme?.formStyle.textFormFieldStyle.errorColor,
        ),
      );

      if (commonTheme != null) {
        theDecoration = theDecoration.copyWith(
          labelStyle: theDecoration.labelStyle != null ? commonTheme.preProcessTextStyle(theDecoration.labelStyle!) : null,
          errorStyle: theDecoration.errorStyle != null ? commonTheme.preProcessTextStyle(theDecoration.errorStyle!) : null,
        );
      }
    }

    if (!widget.enabled) {
      theDecoration = theDecoration.copyWith(
        fillColor: widget.style?.fillColorDisabled ?? commonTheme?.formStyle.textFormFieldStyle.fillColorDisabled,
      );
    }

    if (_isError) {
      theDecoration = theDecoration.copyWith(
        labelStyle: theDecoration.errorStyle?.copyWith(
          color: theDecoration.errorStyle?.color,
        ),
      );
    }

    final theLines = widget.lines > 0 ? widget.lines : 1;
    final theKeyboardType = widget.keyboardType ??
        widget.style?.keyboardType ??
        commonTheme?.formStyle.textFormFieldStyle.keyboardType ??
        (theLines > 1 ? TextInputType.multiline : null);
    final theTextInputAction = widget.textInputAction ?? (theLines > 1 ? TextInputAction.newline : null);

    final List<FormFieldValidation<String>>? theValidations =
        widget.validations ?? widget.style?.validations ?? commonTheme?.formStyle.textFormFieldStyle.validations;

    String? theLabel = widget.label;
    final theHintText = widget.style?.inputDecoration.hintText ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.hintText;

    if (theLabel != null) {
      final theRequiredLabelSuffix = widget.style?.requiredLabelSuffix ?? commonTheme?.formStyle.textFormFieldStyle.requiredLabelSuffix ?? ' *';
      final theShowRequiredLabelSuffix = widget.style?.showRequiredLabelSuffix ??
          commonTheme?.formStyle.textFormFieldStyle.showRequiredLabelSuffix ??
          ShowRequiredLabelSuffix.ByValidateRequired;

      switch (theShowRequiredLabelSuffix) {
        case ShowRequiredLabelSuffix.ByValidateRequired:
          if (theValidations != null) {
            for (FormFieldValidation<String> validation in theValidations) {
              if (validation.validator == validateRequired) {
                theLabel = '$theLabel$theRequiredLabelSuffix';
                break;
              }
            }
          }
          break;
        case ShowRequiredLabelSuffix.Always:
          theLabel = '$theLabel$theRequiredLabelSuffix';
          break;
        case ShowRequiredLabelSuffix.Never:
          // do nothing
          break;
      }
    }

    theDecoration = theDecoration.copyWith(
      hintText: theLabel == null || theLabel.isEmpty ? theHintText : '',
    );

    final theObscureText = widget.obscureText ?? widget.style?.obscureText ?? commonTheme?.formStyle.textFormFieldStyle.obscureText ?? false;

    final thePrefix = widget.prefix ?? widget.style?.inputDecoration.prefix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefix;
    final thePrefixIcon = widget.prefixIcon ?? widget.style?.inputDecoration.prefixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefixIcon;
    final theSuffix = widget.suffix ?? widget.style?.inputDecoration.suffix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffix;
    final suffixIcon = widget.suffixIcon ?? widget.style?.inputDecoration.suffixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffixIcon;

    TextStyle? textStyle = widget.style?.inputStyle ?? commonTheme?.formStyle.textFormFieldStyle.inputStyle;
    TextStyle? disabledTextStyle = widget.style?.disabledInputStyle ?? commonTheme?.formStyle.textFormFieldStyle.disabledInputStyle;
    if (!widget.enabled && disabledTextStyle != null) {
      textStyle = disabledTextStyle;
    }
    if (textStyle != null && commonTheme != null) {
      textStyle = commonTheme.preProcessTextStyle(textStyle);
    }

    Widget field = TextFormField(
      autofocus: widget.autofocus,
      controller: widget.controller,
      focusNode: _focusNode,
      // onChanged: widget.onChanged,
      onFieldSubmitted: (String value) {
        if (theNextFocus != null) {
          final focusScope = FocusScope.of(context);

          focusScope.unfocus();

          focusScope.requestFocus(theNextFocus);
        }

        if (theOnFieldSubmitted != null) {
          theOnFieldSubmitted(value);
        }
      },
      keyboardType: theKeyboardType,
      textInputAction: theTextInputAction,
      style: textStyle,
      decoration: theDecoration.copyWith(
        labelText: theVariant != TextFormFieldVariant.Cupertino ? theLabel : null,
        prefix: thePrefix != null
            ? ValueListenableBuilder(
                valueListenable: _displayPrefix,
                builder: (context, value, child) {
                  if (value) {
                    return thePrefix;
                  }

                  return SizedBox();
                },
              )
            : null,
        prefixIcon: thePrefixIcon != null
            ? ValueListenableBuilder(
                valueListenable: _displayPrefix,
                builder: (context, value, child) {
                  if (value) {
                    return thePrefixIcon;
                  }

                  return SizedBox();
                },
              )
            : null,
        suffix: theSuffix != null
            ? ValueListenableBuilder(
                valueListenable: _displaySuffix,
                builder: (context, value, child) {
                  if (value) {
                    return theSuffix;
                  }

                  return SizedBox();
                },
              )
            : null,
        suffixIcon: suffixIcon != null
            ? ValueListenableBuilder(
                valueListenable: _displaySuffix,
                builder: (context, value, child) {
                  if (value) {
                    return suffixIcon;
                  }

                  return SizedBox();
                },
              )
            : null,
      ),
      textCapitalization: (widget.style?.textCapitalization ?? commonTheme?.formStyle.textFormFieldStyle.textCapitalization) ?? TextCapitalization.none,
      textAlign: (widget.style?.textAlign ?? commonTheme?.formStyle.textFormFieldStyle.textAlign) ?? TextAlign.start,
      minLines: theLines,
      maxLines: theLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLength != null ? MaxLengthEnforcement.enforced : null,
      validator: (String? value) {
        if (theValidations != null) {
          final validated = validateValidations(theValidations, value);

          setStateNotDisposed(() {
            _isError = validated != null;
          });

          return validated;
        }

        return null;
      },
      autocorrect: widget.autocorrect,
      enabled: widget.enabled,
      obscureText: theObscureText,
    );

    Widget content = field;

    if (theVariant == TextFormFieldVariant.Cupertino && theLabel != null) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: (widget.style?.cupertinoLabelPadding ?? commonTheme?.formStyle.textFormFieldStyle.cupertinoLabelPadding) ??
                const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Text(
              theLabel,
              style: theDecoration.labelStyle,
            ),
          ),
          content,
        ],
      );
    }

    if (fullWidthMobileOnly) {
      content = Container(
        width: kPhoneStopBreakpoint,
        child: content,
      );
    }

    if (animatedSizeChanges) {
      content = AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    return Container(
      key: _wrapperKey,
      child: content,
    );
  }

  /// Listen to text changes on TextEditingController and update prefix/suffix display
  void _controllerTextChanged() {
    if (widget.controller.text.isEmpty) {
      if (widget.prefixOnlyWhenNotEmpty) {
        _displayPrefix.value = false;
      }

      if (widget.suffixOnlyWhenNotEmpty) {
        _displaySuffix.value = false;
      }
    } else {
      if (widget.prefixOnlyWhenNotEmpty) {
        _displayPrefix.value = true;
      }

      if (widget.suffixOnlyWhenNotEmpty) {
        _displaySuffix.value = true;
      }
    }
  }
}

enum TextFormFieldVariant {
  None,
  Material,
  Cupertino,
}

enum ShowRequiredLabelSuffix {
  ByValidateRequired,
  Never,
  Always,
}

class TextFormFieldStyle {
  final bool? fullWidthMobileOnly;
  final TextFormFieldVariant variant;
  final TextStyle inputStyle;
  final TextStyle disabledInputStyle;
  final String? iOSFontFamily;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final InputDecoration inputDecoration;
  final Color borderColor;
  final Color fillColorDisabled;
  final Color disabledBorderColor;
  final Color focusedBorderColor;
  final Color errorColor;
  final EdgeInsets cupertinoLabelPadding;
  final List<FormFieldValidation<String>>? validations;
  final bool? obscureText;
  final String requiredLabelSuffix;
  final ShowRequiredLabelSuffix showRequiredLabelSuffix;

  /// TextFormFieldStyle initialization
  const TextFormFieldStyle({
    this.fullWidthMobileOnly,
    this.variant = TextFormFieldVariant.Material,
    this.inputStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.disabledInputStyle = const TextStyle(color: Colors.grey, fontSize: 16),
    this.iOSFontFamily,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.inputDecoration = const InputDecoration(
      isDense: true,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kCommonHorizontalMarginHalf,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      errorStyle: const TextStyle(fontSize: 16),
    ),
    this.borderColor = Colors.black,
    this.fillColorDisabled = Colors.grey,
    this.disabledBorderColor = Colors.grey,
    this.focusedBorderColor = Colors.black,
    this.errorColor = Colors.red,
    this.cupertinoLabelPadding = const EdgeInsets.only(left: 8, right: 8, bottom: 8),
    this.validations = const <FormFieldValidation<String>>[],
    this.obscureText,
    this.requiredLabelSuffix = ' *',
    this.showRequiredLabelSuffix = ShowRequiredLabelSuffix.ByValidateRequired,
  });

  /// Create copy of this style with changes
  TextFormFieldStyle copyWith({
    bool? fullWidthMobileOnly,
    TextFormFieldVariant? variant,
    bool? iOSUseNativeTextField,
    TextStyle? inputStyle,
    TextStyle? disabledInputStyle,
    String? iOSFontFamily,
    TextCapitalization? textCapitalization,
    TextAlign? textAlign,
    TextInputType? keyboardType,
    InputDecoration? inputDecoration,
    Color? borderColor,
    Color? fillColorDisabled,
    Color? disabledBorderColor,
    Color? focusedBorderColor,
    Color? errorColor,
    EdgeInsets? cupertinoLabelPadding,
    List<FormFieldValidation<String>>? validations,
    bool? obscureText,
    String? requiredLabelSuffix,
    ShowRequiredLabelSuffix? showRequiredLabelSuffix,
  }) {
    return TextFormFieldStyle(
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      variant: variant ?? this.variant,
      inputStyle: inputStyle ?? this.inputStyle,
      disabledInputStyle: disabledInputStyle ?? this.disabledInputStyle,
      iOSFontFamily: iOSFontFamily ?? this.iOSFontFamily,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      textAlign: textAlign ?? this.textAlign,
      keyboardType: keyboardType ?? this.keyboardType,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      borderColor: borderColor ?? this.borderColor,
      fillColorDisabled: fillColorDisabled ?? this.fillColorDisabled,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorColor: errorColor ?? this.errorColor,
      cupertinoLabelPadding: cupertinoLabelPadding ?? this.cupertinoLabelPadding,
      validations: validations ?? this.validations,
      obscureText: obscureText ?? this.obscureText,
      requiredLabelSuffix: requiredLabelSuffix ?? this.requiredLabelSuffix,
      showRequiredLabelSuffix: showRequiredLabelSuffix ?? this.showRequiredLabelSuffix,
    );
  }
}

class _IOSUseNativeTextFieldParams extends DataModel {
  String? iOSFontFamily;
  String text;
  TextStyle? inputStyle;
  String? hintText;
  TextStyle? hintStyle;
  int maxLines;
  int? maxLength;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  TextCapitalization textCapitalization;
  TextAlign textAlign;
  bool autocorrect;
  bool obscureText;

  /// IOSUseNativeTextFieldParams initialization
  _IOSUseNativeTextFieldParams({
    this.iOSFontFamily,
    required this.text,
    this.inputStyle,
    this.hintText,
    this.hintStyle,
    required this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.obscureText = false,
  }) : super.fromJson(<String, dynamic>{});

  /// Convert into JSON map
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic>? _inputStyle;
    if (inputStyle != null) {
      _inputStyle = <String, dynamic>{
        'color': inputStyle!.color?.toHex(),
        'fontSize': inputStyle!.fontSize,
        'fontWeightBold': inputStyle!.fontWeight == FontWeight.bold,
        'fontFamily': inputStyle!.fontFamily ?? "",
      };
    }

    Map<String, dynamic>? _hintStyle;
    if (hintStyle != null) {
      _hintStyle = <String, dynamic>{
        'color': hintStyle!.color?.toHex(),
        'fontSize': hintStyle!.fontSize,
        'fontWeightBold': hintStyle!.fontWeight == FontWeight.bold,
        'fontFamily': hintStyle!.fontFamily ?? "",
      };
    }

    return <String, dynamic>{
      'iOSFontFamily': iOSFontFamily ?? '',
      'text': text,
      'inputStyle': _inputStyle,
      'hintText': hintText,
      'hintStyle': _hintStyle,
      'maxLines': maxLines,
      'maxLength': maxLength ?? 0,
      'keyboardType': keyboardType?.toJson()['name'],
      'textInputAction': textInputAction?.toString(),
      'textCapitalization': textCapitalization.toString(),
      'textAlign': textAlign.toString(),
      'autocorrect': autocorrect,
      'obscureText': obscureText,
    };
  }
}
