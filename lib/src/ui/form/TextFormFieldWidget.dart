import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_appliable_core/utils/Color.dart';

class TextFormFieldWidget extends AbstractStatefulWidget {
  final TextFormFieldStyle? style;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? label;
  final int lines;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autocorrect;

  /// TextFormFieldWidget initialization
  TextFormFieldWidget({
    this.style,
    Key? key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.label,
    this.lines = 1,
    this.validator,
    this.enabled = true,
    this.autocorrect = true,
  })  : assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends AbstractStatefulWidgetState<TextFormFieldWidget> with TickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isError = false;
  GlobalKey? _uiKitKey;
  MethodChannel? _methodChannel;

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
    if (widget.style != null) {
      iOSUseNativeTextField = widget.style!.iOSUseNativeTextField;
    } else if (commonTheme != null) {
      iOSUseNativeTextField = commonTheme.formStyle.textFormFieldStyle.iOSUseNativeTextField;
    }

    if (iOSUseNativeTextField && !kIsWeb && Platform.isIOS) {
      _uiKitKey = GlobalKey();

      widget.controller.addListener(_controllerTextChangedForIOSNativeTextField);

      _focusNode.addListener(_focusChangedForIOSNativeTextField);
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    bool iOSUseNativeTextField = true;
    if (widget.style != null) {
      iOSUseNativeTextField = widget.style!.iOSUseNativeTextField;
    } else if (commonTheme != null) {
      iOSUseNativeTextField = commonTheme.formStyle.textFormFieldStyle.iOSUseNativeTextField;
    }

    final bool animatedSizeChanges = commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    InputDecoration theDecoration = (widget.style?.inputDecoration ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration) ?? InputDecoration();

    if (commonTheme != null && widget.style?.inputDecoration == null) {
      theDecoration = theDecoration.copyWith(
        labelStyle: commonTheme.preProcessTextStyle(theDecoration.labelStyle!),
        enabledBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.enabledBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.enabledBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        disabledBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.disabledBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.disabledBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.disabledBorderColor,
          ),
        ),
        focusedBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        errorBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.errorBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.errorBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        focusedErrorBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedErrorBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedErrorBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        errorStyle: commonTheme.preProcessTextStyle(theDecoration.errorStyle!).copyWith(
              color: commonTheme.formStyle.textFormFieldStyle.errorColor,
            ),
      );
    }

    if (!widget.enabled) {
      theDecoration = theDecoration.copyWith(
        fillColor: widget.style?.fillColorDisabled ?? commonTheme?.formStyle.textFormFieldStyle.fillColorDisabled,
      );
    }

    if (_isError) {
      theDecoration = theDecoration.copyWith(
        labelStyle: theDecoration.errorStyle?.copyWith(
          color: widget.style?.errorColor ?? commonTheme?.formStyle.textFormFieldStyle.errorColor,
        ),
      );
    }

    final theLines = widget.lines > 0 ? widget.lines : 1;

    late Widget field;

    if (iOSUseNativeTextField && !kIsWeb && Platform.isIOS) {
      final creationParams = _IOSUseNativeTextFieldParams(
        text: widget.controller.text,
        inputStyle: widget.style?.inputStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.textFormFieldStyle.inputStyle),
        maxLines: theLines,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
      );

      field = IgnorePointer(
        ignoring: !widget.enabled,
        child: InputDecorator(
          decoration: theDecoration.copyWith(labelText: widget.label),
          baseStyle: widget.style?.inputStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.textFormFieldStyle.inputStyle),
          //TODO WIP only autoNextFocus, others work
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
      );
    } else {
      field = TextFormField(
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
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.style?.inputStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.textFormFieldStyle.inputStyle),
        decoration: theDecoration.copyWith(labelText: widget.label),
        textCapitalization: widget.textCapitalization,
        minLines: theLines,
        maxLines: theLines,
        validator: (String? value) {
          final theValidator = widget.validator;
          if (theValidator != null) {
            final validated = theValidator(value);

            setStateNotDisposed(() {
              _isError = validated != null;
            });

            return validated;
          }

          return null;
        },
        autocorrect: widget.autocorrect,
        enabled: widget.enabled,
      );
    }

    Widget content = field;

    if (fullWidthMobileOnly) {
      content = Container(
        width: kPhoneStopBreakpoint,
        child: content,
      );
    }

    if (animatedSizeChanges) {
      content = AnimatedSize(
        vsync: this,
        duration: kThemeAnimationDuration,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    return content;
  }

  /// Response to message from platform
  Future<dynamic> _onMethodCall(MethodCall call) async {
    print('TCH_d onMethodCall ${call.method}'); //TODO remove
    switch (call.method) {
      case "focused":
        _focusIOSNativeTextField();
        break;
      case "didEndEditing":
        _didEndEditingIOSNativeTextField(call.arguments as String);
        break;
    }
  }

  /// On TextEditingController change text update Widget text
  void _controllerTextChangedForIOSNativeTextField() {
    print("TCH_d _controllerTextChangedForIOSNativeTextField"); //TODO remove

    _methodChannel!.invokeMethod("setText", widget.controller.text);

    setStateNotDisposed(() {});
  }

  /// On FocusNode focus changed update Widget state
  void _focusChangedForIOSNativeTextField() {
    print('TCH_d _focusChangedForIOSNativeTextField ${_focusNode.hasFocus}'); //TODO remove
    if (_focusNode.hasFocus) {
      _methodChannel!.invokeMethod('focus');
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
    SchedulerBinding.instance!.addPostFrameCallback((_) {
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

  /// Widget ended text editing, update controller and emulate onFieldSubmitted
  void _didEndEditingIOSNativeTextField(String text) {
    widget.controller.text = text;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    if (theNextFocus != null) {
      final focusScope = FocusScope.of(context);

      focusScope.unfocus();

      focusScope.requestFocus(theNextFocus);
    }

    if (theOnFieldSubmitted != null) {
      theOnFieldSubmitted(text);
    }

    setStateNotDisposed(() {});
  }
}

class TextFormFieldStyle {
  final bool iOSUseNativeTextField;
  final TextStyle inputStyle;
  final InputDecoration inputDecoration;
  final Color borderColor;
  final Color fillColorDisabled;
  final Color disabledBorderColor;
  final Color errorColor;

  /// TextFormFieldStyle initialization
  const TextFormFieldStyle({
    this.iOSUseNativeTextField = true,
    this.inputStyle = const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
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
    this.errorColor = Colors.red,
  });
}

class _IOSUseNativeTextFieldParams extends DataModel {
  String text;
  TextStyle? inputStyle;
  int maxLines;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  TextCapitalization textCapitalization;

  /// IOSUseNativeTextFieldParams initialization
  _IOSUseNativeTextFieldParams({
    required this.text,
    this.inputStyle,
    required this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
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
        'fontFamily': inputStyle!.fontFamily,
      };
    }

    return <String, dynamic>{
      'text': text,
      'inputStyle': _inputStyle,
      'maxLines': maxLines,
      'keyboardType': keyboardType?.toJson()['name'],
      'textInputAction': textInputAction?.toString(),
      'textCapitalization': textCapitalization.toString(),
    };
  }
}
