import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/form.dart';
import 'package:tch_appliable_core/utils/widget.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_appliable_core/utils/Color.dart';
import 'package:tch_common_widgets/src/ui/form/Form.dart';

class TextFormFieldWidget extends AbstractStatefulWidget {
  final bool? iOSUseNativeTextField;
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
  final Widget? suffix;
  final Widget? suffixIcon;
  final int lines;
  final int? maxLength;
  final List<FormFieldValidation<String>>? validations;
  final bool enabled;
  final bool autocorrect;
  final bool? obscureText;

  /// TextFormFieldWidget initialization
  TextFormFieldWidget({
    this.iOSUseNativeTextField,
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
    this.suffix,
    this.suffixIcon,
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
  String? _errorText;
  GlobalKey? _uiKitKey;
  MethodChannel? _methodChannel;
  String? _ignoreSetTextOnIOSNativeTextField;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
  }

  /// Manually dispose of resources
  @override
  void dispose() {
    _methodChannel = null;

    widget.controller.removeListener(_controllerTextChangedForIOSNativeTextField);

    _focusNode.removeListener(_focusChangedForIOSNativeTextField);

    super.dispose();
  }

  /// Run initializations of screen on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    final commonTheme = CommonTheme.of(context);

    bool iOSUseNativeTextField = true;
    if (widget.iOSUseNativeTextField != null) {
      iOSUseNativeTextField = widget.iOSUseNativeTextField!;
    } else if (widget.style != null) {
      iOSUseNativeTextField = widget.style!.iOSUseNativeTextField;
    } else if (commonTheme != null) {
      iOSUseNativeTextField = commonTheme.formStyle.textFormFieldStyle.iOSUseNativeTextField;
    }

    if (iOSUseNativeTextField && !kIsWeb && Platform.isIOS) {
      _uiKitKey = GlobalKey();

      widget.controller.addListener(_controllerTextChangedForIOSNativeTextField);

      _focusNode.addListener(_focusChangedForIOSNativeTextField);

      if (widget.autofocus) {
        final focusScope = FocusScope.of(context);

        Future.delayed(kThemeAnimationDuration, () {
          focusScope.requestFocus(_focusNode);
        });
      }
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final TextFormFieldVariant theVariant = widget.style?.variant ?? commonTheme?.formStyle.textFormFieldStyle.variant ?? TextFormFieldVariant.Material;

    bool iOSUseNativeTextField = true;
    if (widget.iOSUseNativeTextField != null) {
      iOSUseNativeTextField = widget.iOSUseNativeTextField!;
    } else if (widget.style != null) {
      iOSUseNativeTextField = widget.style!.iOSUseNativeTextField;
    } else if (commonTheme != null) {
      iOSUseNativeTextField = commonTheme.formStyle.textFormFieldStyle.iOSUseNativeTextField;
    }

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

    late Widget field;

    if (iOSUseNativeTextField && !kIsWeb && Platform.isIOS) {
      TextStyle? inputStyle = widget.style?.inputStyle ?? commonTheme?.formStyle.textFormFieldStyle.inputStyle;
      TextStyle? hintStyle = widget.style?.inputDecoration.hintStyle ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.hintStyle;
      if (inputStyle != null && commonTheme != null) {
        inputStyle = commonTheme.preProcessTextStyle(inputStyle);
      }
      if (hintStyle != null && commonTheme != null) {
        hintStyle = commonTheme.preProcessTextStyle(hintStyle);
      }

      final creationParams = _IOSUseNativeTextFieldParams(
        iOSFontFamily: widget.iOSFontFamily ?? commonTheme?.iOSFontFamily,
        text: widget.controller.text,
        inputStyle: inputStyle,
        hintText: theDecoration.hintText,
        hintStyle: hintStyle,
        maxLines: theLines,
        maxLength: widget.maxLength,
        keyboardType: theKeyboardType,
        textInputAction: theTextInputAction,
        textCapitalization: (widget.style?.textCapitalization ?? commonTheme?.formStyle.textFormFieldStyle.textCapitalization) ?? TextCapitalization.none,
        textAlign: (widget.style?.textAlign ?? commonTheme?.formStyle.textFormFieldStyle.textAlign) ?? TextAlign.start,
        autocorrect: widget.autocorrect,
        obscureText: theObscureText,
      );

      addPostFrameCallback((_) {
        _methodChannel?.invokeMethod("sync", creationParams.toJson());
      });

      field = IgnorePointer(
        ignoring: !widget.enabled,
        child: FormField(
          builder: (FormFieldState<String> field) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: theDecoration.copyWith(
                    labelText: theVariant != TextFormFieldVariant.Cupertino ? theLabel : null,
                    prefix: widget.prefix ?? widget.style?.inputDecoration.prefix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefix,
                    prefixIcon:
                        widget.prefixIcon ?? widget.style?.inputDecoration.prefixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefixIcon,
                    suffix: widget.suffix ?? widget.style?.inputDecoration.suffix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffix,
                    suffixIcon:
                        widget.suffixIcon ?? widget.style?.inputDecoration.suffixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffixIcon,
                    hintText: '',
                    errorText: _isError ? _errorText : null,
                  ),
                  baseStyle: widget.style?.inputStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.textFormFieldStyle.inputStyle),
                  isFocused: _focusNode.hasFocus,
                  isEmpty: widget.controller.value.text.isEmpty,
                  expands: false,
                  child: Container(
                    height: theLines * 24, //48, //TODO height by lines, isDense = false does not seem to work right now, check later
                    child: UiKitView(
                      key: _uiKitKey,
                      viewType: 'tch_common_widgets/TextFormFieldWidget',
                      layoutDirection: TextDirection.ltr,
                      creationParams: creationParams.toJson(),
                      creationParamsCodec: const StandardMessageCodec(),
                      onPlatformViewCreated: (int viewId) {
                        _methodChannel = MethodChannel('tch_common_widgets/TextFormFieldWidget$viewId');
                        _methodChannel!.setMethodCallHandler(_onMethodCall);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
          validator: (String? value) {
            value = widget.controller.value.text;

            if (theValidations != null) {
              final validated = validateValidations(theValidations, value);

              setStateNotDisposed(() {
                _isError = validated != null;
                _errorText = validated;
              });

              return validated;
            }

            return null;
          },
        ),
      );
    } else {
      TextStyle? textStyle = widget.style?.inputStyle ?? commonTheme?.formStyle.textFormFieldStyle.inputStyle;
      if (textStyle != null && commonTheme != null) {
        textStyle = commonTheme.preProcessTextStyle(textStyle);
      }

      field = TextFormField(
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
          prefix: widget.prefix ?? widget.style?.inputDecoration.prefix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefix,
          prefixIcon: widget.prefixIcon ?? widget.style?.inputDecoration.prefixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.prefixIcon,
          suffix: widget.suffix ?? widget.style?.inputDecoration.suffix ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffix,
          suffixIcon: widget.suffixIcon ?? widget.style?.inputDecoration.suffixIcon ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration.suffixIcon,
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
    }

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

  /// Response to message from platform
  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "focused":
        _focusIOSNativeTextField();
        break;
      case "setText":
        _setTextFromIOSNativeTextField(call.arguments as String);
        break;
      case "didEndEditing":
        _didEndEditingIOSNativeTextField(call.arguments as String);
        break;
    }
  }

  /// On TextEditingController change text update Widget text
  void _controllerTextChangedForIOSNativeTextField() {
    if (widget.controller.text != _ignoreSetTextOnIOSNativeTextField) {
      _methodChannel!.invokeMethod("setText", widget.controller.text);

      setStateNotDisposed(() {});
    }

    _ignoreSetTextOnIOSNativeTextField = null;
  }

  /// On FocusNode focus changed update Widget state
  void _focusChangedForIOSNativeTextField() {
    if (_focusNode.hasFocus) {
      _methodChannel!.invokeMethod('focus');

      final contextOfWrapper = _wrapperKey.currentContext;

      if (contextOfWrapper != null) {
        Future.delayed(kThemeAnimationDuration, () {
          Scrollable.ensureVisible(
            contextOfWrapper,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        });
      }
    } else {
      _methodChannel!.invokeMethod('unFocus');

      _methodChannel!.invokeMethod<String>('getText').then((String? text) {
        setStateNotDisposed(() {
          widget.controller.text = text ?? "";
        });
      });
    }

    setStateNotDisposed(() {});
  }

  /// Make sure Widget is visible on screen and set focus
  void _focusIOSNativeTextField() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.findRenderObject()!.showOnScreen(
              duration: kThemeAnimationDuration,
              curve: Curves.linear,
            );
      }
    });

    if (!_focusNode.hasFocus) {
      final focusScope = FocusScope.of(context);

      focusScope.unfocus();

      focusScope.requestFocus(_focusNode);
    }
  }

  /// Make sure Widget text is synchronized
  void _setTextFromIOSNativeTextField(String text) {
    _ignoreSetTextOnIOSNativeTextField = text;

    widget.controller.text = text;
  }

  /// Widget ended text editing, update controller and emulate onFieldSubmitted
  void _didEndEditingIOSNativeTextField(String text) {
    widget.controller.text = text;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    if (theNextFocus != null) {
      clearFocus(context);

      addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(theNextFocus);
      });
    }

    if (theOnFieldSubmitted != null) {
      theOnFieldSubmitted(text);
    }

    setStateNotDisposed(() {});
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
  final bool iOSUseNativeTextField;
  final TextStyle inputStyle;
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
    this.iOSUseNativeTextField = false,
    this.inputStyle = const TextStyle(color: Colors.black, fontSize: 16),
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
      iOSUseNativeTextField: iOSUseNativeTextField ?? this.iOSUseNativeTextField,
      inputStyle: inputStyle ?? this.inputStyle,
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
