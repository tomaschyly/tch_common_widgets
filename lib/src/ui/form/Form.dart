import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/ui/form/PreferencesSwitchWidget.dart';
import 'package:tch_common_widgets/src/ui/form/TextFormFieldWidget.dart';

class FormStyle {
  final bool animatedSizeChanges;
  final bool fullWidthMobileOnly;
  final TextFormFieldStyle textFormFieldStyle;
  final PreferencesSwitchStyle preferencesSwitchStyle;

  /// FormStyle initialization
  const FormStyle({
    this.animatedSizeChanges = true,
    this.fullWidthMobileOnly = true,
    this.textFormFieldStyle = const TextFormFieldStyle(),
    this.preferencesSwitchStyle = const PreferencesSwitchStyle(),
  });

  /// Create copy if this style with changes
  FormStyle copyWith({
    bool? animatedSizeChanges,
    bool? fullWidthMobileOnly,
    TextFormFieldStyle? textFormFieldStyle,
    PreferencesSwitchStyle? preferencesSwitchStyle,
  }) {
    return FormStyle(
      animatedSizeChanges: animatedSizeChanges ?? this.animatedSizeChanges,
      fullWidthMobileOnly: fullWidthMobileOnly ?? this.fullWidthMobileOnly,
      textFormFieldStyle: textFormFieldStyle ?? this.textFormFieldStyle,
      preferencesSwitchStyle: preferencesSwitchStyle ?? this.preferencesSwitchStyle,
    );
  }
}

class FormFieldValidation<T> {
  final FormFieldValidator<T> validator;
  final String errorText;

  /// FormFieldValidation initialization
  const FormFieldValidation({
    required this.validator,
    required this.errorText,
  });

  /// Validate the value using validator
  String? validate(T? value) => validator(value);
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
