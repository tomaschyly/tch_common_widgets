import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/Boundary.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/form/Form.dart';
import 'package:tch_common_widgets/src/ui/form/TextFormFieldWidget.dart';

class DatePickerFormFieldWidget extends AbstractStatefulWidget {
  final DatePickerFormFieldStyle? style;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChange;
  final List<FormFieldValidation<DateTime>>? validations;

  /// DatePickerFormFieldWidget initialization
  DatePickerFormFieldWidget({
    GlobalKey<DatePickerFormFieldWidgetState>? key,
    this.style,
    this.dateFormat,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.onChange,
    this.validations,
  })  : assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => DatePickerFormFieldWidgetState();
}

class DatePickerFormFieldWidgetState extends AbstractStatefulWidgetState<DatePickerFormFieldWidget> {
  DateTime? get value => _value;

  final GlobalKey _fieldKey = GlobalKey();
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
    if (_focusNode == null) {
      _focusNode = FocusNode();
    }
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
    if (_focusNode == null) {
      _focusNode = FocusNode();
    }
    _focusNode!.addListener(_focusChanged);
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final inputStyle = widget.style?.inputStyle ?? commonTheme?.formStyle.selectionFormFieldStyle.inputStyle ?? const TextFormFieldStyle();

    final borderRadius = widget.style?.borderRadius ?? commonTheme?.formStyle.selectionFormFieldStyle.borderRadius;

    final dateFormat = widget.dateFormat ?? widget.style?.dateFormat ?? commonTheme?.formStyle.datePickerFormFieldStyle.dateFormat ?? DateFormat.yMMMMEEEEd();

    final theBoundary = _fieldBoundary;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateHeight();

      if (_value != null) {
        _controller.text = dateFormat.format(_value!);
      } else {
        _controller.text = "";
      }
    });

    Widget? control;

    if (theBoundary != null) {
      control = Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
            height: theBoundary.height,
          ),
          onTap: () {
            _selectDate(context);
          },
        ),
      );

      if (borderRadius != null) {
        control = ClipRRect(
          borderRadius: borderRadius,
          child: control,
        );
      }
    }

    final theValidations = widget.validations;

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
                    final validated = validateValidations(theValidations, _value);

                    _errorText = validated ?? '';

                    return validated == null;
                  },
                  errorText: '',
                  dynamicErrorText: () => _errorText,
                ),
            ],
          ),
        ),
        if (control != null) control,
      ],
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

  /// Use Material DatePicker to select Date
  Future<void> _selectDate(BuildContext context) async {
    final commonTheme = CommonTheme.of(context);
    final focusScope = FocusScope.of(context);

    focusScope.unfocus();

    final DateTime firstDate = widget.firstDate ?? Jiffy().startOf(Units.YEAR).dateTime;
    final DateTime lastDate = widget.lastDate ?? Jiffy().add(years: 1).endOf(Units.YEAR).dateTime;

    final bool cancelClearsValue = widget.style?.cancelClearsValue ?? commonTheme?.formStyle.datePickerFormFieldStyle.cancelClearsValue ?? true;
    final Color backgroundColor = widget.style?.backgroundColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.backgroundColor ?? Colors.black;
    final Color headerTextColor = widget.style?.headerTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.headerTextColor ?? Colors.white;
    final Color bodyTextColor = widget.style?.bodyTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.bodyTextColor ?? Colors.black;
    final Color buttonTextColor = widget.style?.buttonTextColor ?? commonTheme?.formStyle.datePickerFormFieldStyle.buttonTextColor ?? Colors.black;

    final DateTime? newValue = await showDatePicker(
      context: context,
      initialDate: _value ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
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
                primary: buttonTextColor,
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
  final DateFormat? dateFormat;
  final bool cancelClearsValue;
  final Color backgroundColor;
  final Color headerTextColor;
  final Color bodyTextColor;
  final Color buttonTextColor;

  /// DatePickerFormFieldStyle initialization
  const DatePickerFormFieldStyle({
    this.inputStyle = const TextFormFieldStyle(),
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
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
      dateFormat: dateFormat ?? this.dateFormat,
      cancelClearsValue: cancelClearsValue ?? this.cancelClearsValue,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
    );
  }
}
