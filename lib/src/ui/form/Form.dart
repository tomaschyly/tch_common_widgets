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
}
