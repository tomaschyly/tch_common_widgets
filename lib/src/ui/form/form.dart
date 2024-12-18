import 'package:tch_common_widgets/src/ui/form/calendar_widget.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class FormStyle {
  final bool animatedSizeChanges;
  final bool fullWidthMobileOnly;
  final PreferencesSwitchStyle preferencesSwitchStyle;
  final SelectionFormFieldStyle selectionFormFieldStyle;
  final SwitchToggleWidgetStyle switchToggleWidgetStyle;
  final TextFormFieldStyle textFormFieldStyle;
  final DatePickerFormFieldStyle datePickerFormFieldStyle;
  final CalendarWidgetStyle calendarWidgetStyle;

  /// FormStyle initialization
  const FormStyle({
    this.animatedSizeChanges = true,
    this.fullWidthMobileOnly = true,
    this.preferencesSwitchStyle = const PreferencesSwitchStyle(),
    this.selectionFormFieldStyle = const SelectionFormFieldStyle(),
    this.switchToggleWidgetStyle = const SwitchToggleWidgetStyle(useText: true),
    this.textFormFieldStyle = const TextFormFieldStyle(),
    this.datePickerFormFieldStyle = const DatePickerFormFieldStyle(),
    this.calendarWidgetStyle = const CalendarWidgetStyle(),
  });

  /// Create copy if this style with changes
  FormStyle copyWith({
    bool? animatedSizeChanges,
    bool? fullWidthMobileOnly,
    PreferencesSwitchStyle? preferencesSwitchStyle,
    SelectionFormFieldStyle? selectionFormFieldStyle,
    SwitchToggleWidgetStyle? switchToggleWidgetStyle,
    TextFormFieldStyle? textFormFieldStyle,
    DatePickerFormFieldStyle? datePickerFormFieldStyle,
    CalendarWidgetStyle? calendarWidgetStyle,
  }) {
    return FormStyle(
      animatedSizeChanges: animatedSizeChanges ?? this.animatedSizeChanges,
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      preferencesSwitchStyle: preferencesSwitchStyle ?? this.preferencesSwitchStyle,
      selectionFormFieldStyle: selectionFormFieldStyle ?? this.selectionFormFieldStyle,
      switchToggleWidgetStyle: switchToggleWidgetStyle ?? this.switchToggleWidgetStyle,
      textFormFieldStyle: textFormFieldStyle ?? this.textFormFieldStyle,
      datePickerFormFieldStyle: datePickerFormFieldStyle ?? this.datePickerFormFieldStyle,
      calendarWidgetStyle: calendarWidgetStyle ?? this.calendarWidgetStyle,
    );
  }
}

class FormFieldValidation<T> {
  final bool Function(T? value) validator;
  final String errorText;
  late final String Function() dynamicErrorText;

  /// FormFieldValidation initialization
  FormFieldValidation({
    required this.validator,
    required this.errorText,
    String Function()? dynamicErrorText,
  }) {
    this.dynamicErrorText = dynamicErrorText ?? _dynamicErrorText;
  }

  /// Validate the value using validator
  String? validate(T? value) => validator(value) ? null : dynamicErrorText();

  /// Returns errorText dynamically, can be replaced by custom method when complex validations are required
  String _dynamicErrorText() => errorText;
}

/// Validate all provided FormFieldValidations, stop on first error and return it
String? validateValidations<T>(List<FormFieldValidation<T>> validations, T? value) {
  for (FormFieldValidation<T> validation in validations) {
    final validated = validation.validate(value);

    if (validated != null) {
      return validated;
    }
  }

  return null;
}

/// Validate String value is not empty
bool validateRequired(String? value) => value != null && value.isNotEmpty;

const kEmailPattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

/// Validate String value is valid email
bool validateEmail(String? value) => value == null || value.isEmpty || RegExp(kEmailPattern, caseSensitive: false).hasMatch(value);
