import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/boundary.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class DatePickerFormFieldWidget extends AbstractStatefulWidget {
  final DatePickerFormFieldStyle? style;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? selectionTitle;
  final String? cancelText;
  final String? confirmText;
  final String? fieldLabelText;
  final String? fieldHintText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChange;
  final List<FormFieldValidation<DateTime>>? validations;

  /// DatePickerFormFieldWidget initialization
  const DatePickerFormFieldWidget({
    super.key,
    this.style,
    this.dateFormat,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.selectionTitle,
    this.cancelText,
    this.confirmText,
    this.fieldLabelText,
    this.fieldHintText,
    this.errorFormatText,
    this.errorInvalidText,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.onChange,
    this.validations,
  }) : assert((focusNode == null && nextFocus == null) || focusNode != null);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => DatePickerFormFieldWidgetState();
}

class DatePickerFormFieldWidgetState
    extends AbstractStatefulWidgetState<DatePickerFormFieldWidget> {
  DateTime? get value => _value;

  final GlobalKey _fieldKey = GlobalKey();
  bool _isHovered = false;
  FocusNode? _focusNode;
  DateTime? _value;
  final TextEditingController _controller = TextEditingController();
  Boundary? _fieldBoundary;
  String _errorText = '';

  /// State initialization
  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode;
    _focusNode ??= FocusNode();
    _focusNode!.addListener(_focusChanged);

    _value = widget.initialValue;
  }

  /// Dispose of resources manually
  @override
  void dispose() {
    _controller.dispose();

    if (widget.focusNode == null) {
      _focusNode!.dispose();
    }

    super.dispose();
  }

  /// Widget parameters changed
  @override
  void didUpdateWidget(covariant DatePickerFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _focusNode!.removeListener(_focusChanged);
    _focusNode = widget.focusNode;
    _focusNode ??= FocusNode();
    _focusNode!.addListener(_focusChanged);
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly =
        commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final baseInputStyle =
        widget.style?.inputStyle ??
        commonTheme?.formStyle.datePickerFormFieldStyle.inputStyle ??
        const TextFormFieldStyle();

    final baseBorderRadius =
        widget.style?.borderRadius ??
        commonTheme?.formStyle.datePickerFormFieldStyle.borderRadius;
    final baseMouseCursor =
        widget.style?.mouseCursor ??
        commonTheme?.formStyle.datePickerFormFieldStyle.mouseCursor ??
        SystemMouseCursors.click;
    final hoverStyle =
        widget.style?.hoverStyle ??
        commonTheme?.formStyle.datePickerFormFieldStyle.hoverStyle;
    final hoverInputStyle = hoverStyle?.inputStyle ?? baseInputStyle;
    final hoverBorderRadius = hoverStyle?.borderRadius ?? baseBorderRadius;
    final hoverMouseCursor = hoverStyle?.mouseCursor ?? baseMouseCursor;
    final animationDuration =
        widget.style?.animationDuration ??
        commonTheme?.formStyle.datePickerFormFieldStyle.animationDuration ??
        kThemeAnimationDuration;
    final animationCurve =
        widget.style?.animationCurve ??
        commonTheme?.formStyle.datePickerFormFieldStyle.animationCurve ??
        Curves.easeOut;

    final dateFormat =
        widget.dateFormat ??
        widget.style?.dateFormat ??
        commonTheme?.formStyle.datePickerFormFieldStyle.dateFormat ??
        DateFormat.yMMMMEEEEd();

    final theBoundary = _fieldBoundary;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateHeight();

      if (_value != null) {
        _controller.text = dateFormat.format(_value!);
      } else {
        _controller.text = '';
      }
    });

    final theValidations = widget.validations;
    final isHoverActive = _isHovered && hoverStyle != null;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isHoverActive ? 1 : 0),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, double hoverProgress, Widget? child) {
        final inputStyle = _interpolateInputStyle(
          baseInputStyle,
          hoverInputStyle,
          hoverProgress,
        );
        final borderRadius = BorderRadius.lerp(
          baseBorderRadius,
          hoverBorderRadius,
          hoverProgress,
        );
        final mouseCursor =
            hoverProgress < 0.5 ? baseMouseCursor : hoverMouseCursor;

        Widget? control;

        if (theBoundary != null) {
          control = Material(
            color: Colors.transparent,
            child: InkWell(
              mouseCursor: mouseCursor,
              onHover: _setHoverState,
              onTap: () {
                _selectDate(context);
              },
              child: SizedBox(
                width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
                height: theBoundary.height,
              ),
            ),
          );

          if (borderRadius != null) {
            control = ClipRRect(
              borderRadius: borderRadius,
              child: control,
            );
          }
        }

        return Stack(
          children: [
            IgnorePointer(
              ignoring: true,
              child: TextFormFieldWidget(
                key: _fieldKey,
                style: inputStyle,
                controller: _controller,
                focusNode: _focusNode,
                nextFocus: widget.nextFocus,
                label: widget.label,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                validations: [
                  if (theValidations != null)
                    FormFieldValidation(
                      validator: (String? value) {
                        final validated = validateValidations(
                          theValidations,
                          _value,
                        );

                        _errorText = validated ?? '';

                        return validated == null;
                      },
                      errorText: '',
                      dynamicErrorText: () => _errorText,
                    ),
                ],
              ),
            ),
            ?control,
          ],
        );
      },
    );
  }

  /// Use TextFormFieldWidget height for InkWell height
  void _calculateHeight() {
    if (_fieldKey.currentContext != null && _fieldBoundary == null) {
      final RenderBox renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;

      final boundary = Boundary(renderBox.size.width, renderBox.size.height, 0, 0);

      if (boundary.height != _fieldBoundary?.height) {
        setStateNotDisposed(() {
          _fieldBoundary = boundary;
        });
      }
    }
  }

  /// On TextFormFieldWidget hasFocus, resign focus as it should not be interactive
  void _focusChanged() {
    if (_focusNode!.hasFocus) {
      _focusNode!.unfocus();

      _selectDate(context);
    }
  }

  /// Update hover state and rebuild only when value changes
  void _setHoverState(bool isHovered) {
    if (_isHovered == isHovered) {
      return;
    }

    setStateNotDisposed(() {
      _isHovered = isHovered;
    });
  }

  /// Interpolate TextFormFieldStyle for hover animation
  TextFormFieldStyle _interpolateInputStyle(
    TextFormFieldStyle fromStyle,
    TextFormFieldStyle toStyle,
    double progress,
  ) {
    return fromStyle.copyWith(
      inputStyle:
          TextStyle.lerp(fromStyle.inputStyle, toStyle.inputStyle, progress) ??
          (progress < 0.5 ? fromStyle.inputStyle : toStyle.inputStyle),
      disabledInputStyle:
          TextStyle.lerp(
            fromStyle.disabledInputStyle,
            toStyle.disabledInputStyle,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.disabledInputStyle
              : toStyle.disabledInputStyle),
      inputDecoration: _interpolateInputDecoration(
        fromStyle.inputDecoration,
        toStyle.inputDecoration,
        progress,
      ),
      borderColor:
          Color.lerp(fromStyle.borderColor, toStyle.borderColor, progress) ??
          (progress < 0.5 ? fromStyle.borderColor : toStyle.borderColor),
      fillColorDisabled:
          Color.lerp(
            fromStyle.fillColorDisabled,
            toStyle.fillColorDisabled,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.fillColorDisabled
              : toStyle.fillColorDisabled),
      disabledBorderColor:
          Color.lerp(
            fromStyle.disabledBorderColor,
            toStyle.disabledBorderColor,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.disabledBorderColor
              : toStyle.disabledBorderColor),
      focusedBorderColor:
          Color.lerp(
            fromStyle.focusedBorderColor,
            toStyle.focusedBorderColor,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.focusedBorderColor
              : toStyle.focusedBorderColor),
      errorColor:
          Color.lerp(fromStyle.errorColor, toStyle.errorColor, progress) ??
          (progress < 0.5 ? fromStyle.errorColor : toStyle.errorColor),
      cupertinoLabelPadding:
          EdgeInsets.lerp(
            fromStyle.cupertinoLabelPadding,
            toStyle.cupertinoLabelPadding,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.cupertinoLabelPadding
              : toStyle.cupertinoLabelPadding),
    );
  }

  /// Interpolate InputDecoration for hover animation
  InputDecoration _interpolateInputDecoration(
    InputDecoration fromDecoration,
    InputDecoration toDecoration,
    double progress,
  ) {
    return fromDecoration.copyWith(
      isDense: progress < 0.5 ? fromDecoration.isDense : toDecoration.isDense,
      fillColor:
          Color.lerp(fromDecoration.fillColor, toDecoration.fillColor, progress),
      labelStyle: TextStyle.lerp(
        fromDecoration.labelStyle,
        toDecoration.labelStyle,
        progress,
      ),
      hintStyle: TextStyle.lerp(
        fromDecoration.hintStyle,
        toDecoration.hintStyle,
        progress,
      ),
      errorStyle: TextStyle.lerp(
        fromDecoration.errorStyle,
        toDecoration.errorStyle,
        progress,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        fromDecoration.contentPadding,
        toDecoration.contentPadding,
        progress,
      ),
      enabledBorder:
          progress < 0.5
              ? fromDecoration.enabledBorder
              : toDecoration.enabledBorder,
      disabledBorder:
          progress < 0.5
              ? fromDecoration.disabledBorder
              : toDecoration.disabledBorder,
      focusedBorder:
          progress < 0.5
              ? fromDecoration.focusedBorder
              : toDecoration.focusedBorder,
      errorBorder:
          progress < 0.5
              ? fromDecoration.errorBorder
              : toDecoration.errorBorder,
      focusedErrorBorder:
          progress < 0.5
              ? fromDecoration.focusedErrorBorder
              : toDecoration.focusedErrorBorder,
    );
  }

  /// Use Material DatePicker to select Date
  Future<void> _selectDate(BuildContext context) async {
    final commonTheme = CommonTheme.of(context);
    final focusScope = FocusScope.of(context);

    focusScope.unfocus();

    final DateTime firstDate = widget.firstDate ?? Jiffy.now().startOf(Unit.year).dateTime;
    final DateTime lastDate = widget.lastDate ?? Jiffy.now().add(years: 1).endOf(Unit.year).dateTime;

    DateTime initialDate = _value ?? DateTime.now();

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final bool cancelClearsValue = widget.style?.cancelClearsValue ?? commonTheme?.formStyle.datePickerFormFieldStyle.cancelClearsValue ?? true;
    final Color backgroundColor = widget.style?.backgroundColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.backgroundColor ?? Colors.black;
    final Color headerTextColor = widget.style?.headerTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.headerTextColor ?? Colors.white;
    final Color bodyTextColor = widget.style?.bodyTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.bodyTextColor ?? Colors.black;
    final Color buttonTextColor = widget.style?.buttonTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.buttonTextColor ?? Colors.black;

    final DateTime? newValue = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: widget.selectionTitle,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      fieldLabelText: widget.fieldLabelText,
      fieldHintText: widget.fieldHintText,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      builder: (BuildContext context, Widget? child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: backgroundColor,
              onPrimary: headerTextColor,
              onSurface: bodyTextColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: buttonTextColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newValue == null && !cancelClearsValue) {
      return;
    }

    setStateNotDisposed(() {
      _value = newValue;
    });

    final theOnChange = widget.onChange;
    if (theOnChange != null) {
      theOnChange(newValue);
    }

    final theNextFocus = widget.nextFocus;
    if (newValue != null && theNextFocus != null) {
      focusScope.requestFocus(theNextFocus);
    }
  }
}

class DatePickerFormFieldStyle {
  final TextFormFieldStyle inputStyle;
  final BorderRadius? borderRadius;
  final DatePickerFormFieldHoverStyle? hoverStyle;
  final MouseCursor mouseCursor;
  final Duration animationDuration;
  final Curve animationCurve;
  final DateFormat? dateFormat;
  final bool cancelClearsValue;
  final Color backgroundColor;
  final Color headerTextColor;
  final Color bodyTextColor;
  final Color buttonTextColor;

  /// DatePickerFormFieldStyle initialization
  const DatePickerFormFieldStyle({
    this.inputStyle = const TextFormFieldStyle(),
    this.borderRadius = const BorderRadius.all(.circular(8)),
    this.hoverStyle,
    this.mouseCursor = SystemMouseCursors.click,
    this.animationDuration = kThemeAnimationDuration,
    this.animationCurve = Curves.easeOut,
    this.dateFormat,
    this.cancelClearsValue = true,
    this.backgroundColor = Colors.black,
    this.headerTextColor = Colors.white,
    this.bodyTextColor = Colors.black,
    this.buttonTextColor = Colors.black,
  });

  /// Create copy of this style with changes
  DatePickerFormFieldStyle copyWith({
    TextFormFieldStyle? inputStyle,
    BorderRadius? borderRadius,
    DatePickerFormFieldHoverStyle? hoverStyle,
    MouseCursor? mouseCursor,
    Duration? animationDuration,
    Curve? animationCurve,
    DateFormat? dateFormat,
    bool? cancelClearsValue,
    Color? backgroundColor,
    Color? headerTextColor,
    Color? bodyTextColor,
    Color? buttonTextColor,
  }) {
    return DatePickerFormFieldStyle(
      inputStyle: inputStyle ?? this.inputStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      hoverStyle: hoverStyle ?? this.hoverStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      dateFormat: dateFormat ?? this.dateFormat,
      cancelClearsValue: cancelClearsValue ?? this.cancelClearsValue,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
    );
  }
}

class DatePickerFormFieldHoverStyle {
  final TextFormFieldStyle? inputStyle;
  final BorderRadius? borderRadius;
  final MouseCursor? mouseCursor;

  /// DatePickerFormFieldHoverStyle initialization
  const DatePickerFormFieldHoverStyle({
    this.inputStyle,
    this.borderRadius,
    this.mouseCursor,
  });

  /// Create copy of this hover style with changes
  DatePickerFormFieldHoverStyle copyWith({
    TextFormFieldStyle? inputStyle,
    BorderRadius? borderRadius,
    MouseCursor? mouseCursor,
  }) {
    return DatePickerFormFieldHoverStyle(
      inputStyle: inputStyle ?? this.inputStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }
}
