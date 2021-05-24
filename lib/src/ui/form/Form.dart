import 'package:tch_common_widgets/src/ui/form/PreferencesSwitchWidget.dart';

class FormStyle {
  final bool animatedSizeChanges;
  final bool fullWidthMobileOnly;
  final PreferencesSwitchStyle preferencesSwitchStyle;

  /// FormStyle initialization
  const FormStyle({
    this.animatedSizeChanges = true,
    this.fullWidthMobileOnly = true,
    this.preferencesSwitchStyle = const PreferencesSwitchStyle(),
  });
}
