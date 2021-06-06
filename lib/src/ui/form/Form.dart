import 'package:tch_common_widgets/src/ui/form/PreferencesSwitchWidget.dart';
import 'package:tch_common_widgets/src/ui/form/SelectionFormFieldWidget.dart';
import 'package:tch_common_widgets/src/ui/form/TextFormFieldWidget.dart';

class FormStyle {
  final bool animatedSizeChanges;
  final bool fullWidthMobileOnly;
  final PreferencesSwitchStyle preferencesSwitchStyle;
  final SelectionFormFieldStyle selectionFormFieldStyle;
  final TextFormFieldStyle textFormFieldStyle;

  /// FormStyle initialization
  const FormStyle({
    this.animatedSizeChanges = true,
    this.fullWidthMobileOnly = true,
    this.preferencesSwitchStyle = const PreferencesSwitchStyle(),
    this.selectionFormFieldStyle = const SelectionFormFieldStyle(),
    this.textFormFieldStyle = const TextFormFieldStyle(),
  });

  /// Create copy if this style with changes
  FormStyle copyWith({
    bool? animatedSizeChanges,
    bool? fullWidthMobileOnly,
    PreferencesSwitchStyle? preferencesSwitchStyle,
    SelectionFormFieldStyle? selectionFormFieldStyle,
    TextFormFieldStyle? textFormFieldStyle,
  }) {
    return FormStyle(
      animatedSizeChanges: animatedSizeChanges ?? this.animatedSizeChanges,
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      preferencesSwitchStyle: preferencesSwitchStyle ?? this.preferencesSwitchStyle,
      selectionFormFieldStyle: selectionFormFieldStyle ?? this.selectionFormFieldStyle,
      textFormFieldStyle: textFormFieldStyle ?? this.textFormFieldStyle,
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
