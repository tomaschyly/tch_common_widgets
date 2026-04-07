import 'package:flutter/services.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class TextFormFieldWidget extends AbstractStatefulWidget {
  final TextFormFieldStyle? style;
  final String? iOSFontFamily;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final FormFieldSetter<String>? onSaved;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
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
  final bool? readOnly;
  final bool? obscureText;

  /// TextFormFieldWidget initialization
  const TextFormFieldWidget({
    super.key,
    this.style,
    this.iOSFontFamily,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.onSaved,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
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
    this.readOnly,
    this.obscureText,
  }) : assert((focusNode == null && nextFocus == null) || focusNode != null);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState
    extends AbstractStatefulWidgetState<TextFormFieldWidget> {
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

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

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

    final TextFormFieldVariant theVariant =
        widget.style?.variant ??
        commonTheme?.formStyle.textFormFieldStyle.variant ??
        .material;

    final bool animatedSizeChanges =
        commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly =
        widget.style?.fullWidthMobileOnly ??
        commonTheme?.formStyle.fullWidthMobileOnly ??
        true;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    InputDecoration theDecoration =
        widget.style?.inputDecoration ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration ??
        InputDecoration();

    if ((widget.style?.inputDecoration ??
            commonTheme?.formStyle.textFormFieldStyle.inputDecoration) !=
        null) {
      theDecoration = theDecoration.copyWith(
        enabledBorder: theDecoration.enabledBorder?.copyWith(
          borderSide: theDecoration.enabledBorder!.borderSide.copyWith(
            color:
                widget.style?.borderColor ??
                commonTheme?.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        disabledBorder: theDecoration.disabledBorder?.copyWith(
          borderSide: theDecoration.disabledBorder!.borderSide.copyWith(
            color:
                widget.style?.disabledBorderColor ??
                commonTheme?.formStyle.textFormFieldStyle.disabledBorderColor,
          ),
        ),
        focusedBorder: theDecoration.focusedBorder?.copyWith(
          borderSide: theDecoration.focusedBorder!.borderSide.copyWith(
            color:
                widget.style?.focusedBorderColor ??
                commonTheme?.formStyle.textFormFieldStyle.focusedBorderColor,
          ),
        ),
        errorBorder: theDecoration.errorBorder?.copyWith(
          borderSide: theDecoration.errorBorder!.borderSide.copyWith(
            color:
                widget.style?.errorColor ??
                commonTheme?.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        focusedErrorBorder: theDecoration.focusedErrorBorder?.copyWith(
          borderSide: theDecoration.focusedErrorBorder!.borderSide.copyWith(
            color:
                widget.style?.errorColor ??
                commonTheme?.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        errorStyle: theDecoration.errorStyle?.copyWith(
          color:
              widget.style?.errorColor ??
              commonTheme?.formStyle.textFormFieldStyle.errorColor,
        ),
      );

      if (commonTheme != null) {
        theDecoration = theDecoration.copyWith(
          labelStyle: theDecoration.labelStyle != null
              ? commonTheme.preProcessTextStyle(theDecoration.labelStyle!)
              : null,
          errorStyle: theDecoration.errorStyle != null
              ? commonTheme.preProcessTextStyle(theDecoration.errorStyle!)
              : null,
        );
      }
    }

    if (!widget.enabled) {
      theDecoration = theDecoration.copyWith(
        fillColor:
            widget.style?.fillColorDisabled ??
            commonTheme?.formStyle.textFormFieldStyle.fillColorDisabled,
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
    final theKeyboardType =
        widget.keyboardType ??
        widget.style?.keyboardType ??
        commonTheme?.formStyle.textFormFieldStyle.keyboardType ??
        (theLines > 1 ? TextInputType.multiline : null);
    final theTextInputAction =
        widget.textInputAction ??
        (theLines > 1 ? TextInputAction.newline : null);

    final List<FormFieldValidation<String>>? theValidations =
        widget.validations ??
        widget.style?.validations ??
        commonTheme?.formStyle.textFormFieldStyle.validations;

    String? theLabel = widget.label;
    final theHintText =
        widget.style?.inputDecoration.hintText ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration.hintText;

    if (theLabel != null) {
      final theRequiredLabelSuffix =
          widget.style?.requiredLabelSuffix ??
          commonTheme?.formStyle.textFormFieldStyle.requiredLabelSuffix ??
          ' *';
      final theShowRequiredLabelSuffix =
          widget.style?.showRequiredLabelSuffix ??
          commonTheme?.formStyle.textFormFieldStyle.showRequiredLabelSuffix ??
          .byValidateRequired;

      switch (theShowRequiredLabelSuffix) {
        case ShowRequiredLabelSuffix.byValidateRequired:
          if (theValidations != null) {
            for (FormFieldValidation<String> validation in theValidations) {
              if (validation.validator == validateRequired) {
                theLabel = '$theLabel$theRequiredLabelSuffix';
                break;
              }
            }
          }
          break;
        case ShowRequiredLabelSuffix.always:
          theLabel = '$theLabel$theRequiredLabelSuffix';
          break;
        case ShowRequiredLabelSuffix.never:
          // do nothing
          break;
      }
    }

    theDecoration = theDecoration.copyWith(
      hintText: theLabel == null || theLabel.isEmpty ? theHintText : '',
    );

    final theObscureText =
        widget.obscureText ??
        widget.style?.obscureText ??
        commonTheme?.formStyle.textFormFieldStyle.obscureText ??
        false;
    final theInputFormatters =
        widget.inputFormatters ??
        widget.style?.inputFormatters ??
        commonTheme?.formStyle.textFormFieldStyle.inputFormatters;
    final theReadOnly =
        widget.readOnly ??
        widget.style?.readOnly ??
        commonTheme?.formStyle.textFormFieldStyle.readOnly ??
        false;

    final thePrefix =
        widget.prefix ??
        widget.style?.inputDecoration.prefix ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefix;
    final thePrefixIcon =
        widget.prefixIcon ??
        widget.style?.inputDecoration.prefixIcon ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefixIcon;
    final theSuffix =
        widget.suffix ??
        widget.style?.inputDecoration.suffix ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffix;
    final suffixIcon =
        widget.suffixIcon ??
        widget.style?.inputDecoration.suffixIcon ??
        commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffixIcon;

    TextStyle? textStyle =
        widget.style?.inputStyle ??
        commonTheme?.formStyle.textFormFieldStyle.inputStyle;
    TextStyle? disabledTextStyle =
        widget.style?.disabledInputStyle ??
        commonTheme?.formStyle.textFormFieldStyle.disabledInputStyle;
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
      onChanged: widget.onChanged,
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
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onSaved: widget.onSaved,
      keyboardType: theKeyboardType,
      textInputAction: theTextInputAction,
      inputFormatters: theInputFormatters,
      style: textStyle,
      decoration: theDecoration.copyWith(
        labelText: theVariant != TextFormFieldVariant.cupertino
            ? theLabel
            : null,
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
      textCapitalization:
          (widget.style?.textCapitalization ??
              commonTheme?.formStyle.textFormFieldStyle.textCapitalization) ??
          .none,
      textAlign:
          (widget.style?.textAlign ??
              commonTheme?.formStyle.textFormFieldStyle.textAlign) ??
          .start,
      minLines: theLines,
      maxLines: theLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLength != null
          ? MaxLengthEnforcement.enforced
          : null,
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
      readOnly: theReadOnly,
      obscureText: theObscureText,
    );

    Widget content = field;

    if (theVariant == TextFormFieldVariant.cupertino && theLabel != null) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                (widget.style?.cupertinoLabelPadding ??
                    commonTheme
                        ?.formStyle
                        .textFormFieldStyle
                        .cupertinoLabelPadding) ??
                const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Text(theLabel, style: theDecoration.labelStyle),
          ),
          content,
        ],
      );
    }

    if (fullWidthMobileOnly) {
      content = SizedBox(width: kPhoneStopBreakpoint, child: content);
    }

    if (animatedSizeChanges) {
      content = AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    return Container(key: _wrapperKey, child: content);
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

enum TextFormFieldVariant { none, material, cupertino }

enum ShowRequiredLabelSuffix { byValidateRequired, never, always }

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
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final bool? obscureText;
  final String requiredLabelSuffix;
  final ShowRequiredLabelSuffix showRequiredLabelSuffix;

  /// TextFormFieldStyle initialization
  const TextFormFieldStyle({
    this.fullWidthMobileOnly,
    this.variant = .material,
    this.inputStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.disabledInputStyle = const TextStyle(color: Colors.grey, fontSize: 16),
    this.iOSFontFamily,
    this.textCapitalization = .none,
    this.textAlign = .start,
    this.keyboardType,
    this.inputDecoration = const InputDecoration(
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: kCommonHorizontalMarginHalf,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(.circular(8)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(.circular(8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(.circular(8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.all(.circular(8)),
      ),
      errorStyle: TextStyle(fontSize: 16),
    ),
    this.borderColor = Colors.black,
    this.fillColorDisabled = Colors.grey,
    this.disabledBorderColor = Colors.grey,
    this.focusedBorderColor = Colors.black,
    this.errorColor = Colors.red,
    this.cupertinoLabelPadding = const .only(left: 8, right: 8, bottom: 8),
    this.validations = const <FormFieldValidation<String>>[],
    this.inputFormatters,
    this.readOnly,
    this.obscureText,
    this.requiredLabelSuffix = ' *',
    this.showRequiredLabelSuffix = .byValidateRequired,
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
    List<TextInputFormatter>? inputFormatters,
    bool? readOnly,
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
      cupertinoLabelPadding:
          cupertinoLabelPadding ?? this.cupertinoLabelPadding,
      validations: validations ?? this.validations,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      readOnly: readOnly ?? this.readOnly,
      obscureText: obscureText ?? this.obscureText,
      requiredLabelSuffix: requiredLabelSuffix ?? this.requiredLabelSuffix,
      showRequiredLabelSuffix:
          showRequiredLabelSuffix ?? this.showRequiredLabelSuffix,
    );
  }
}
