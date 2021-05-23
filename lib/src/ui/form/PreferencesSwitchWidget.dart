import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class PreferencesSwitchWidget extends AbstractStatefulWidget {
  final String label;
  final String prefsKey;
  final String? descriptionOn;
  final String? descriptionOff;
  final ValueChanged<bool>? onChange;
  final bool invert;

  /// PreferencesSwitchWidget initialization
  PreferencesSwitchWidget({
    required this.label,
    required this.prefsKey,
    this.descriptionOn,
    this.descriptionOff,
    this.onChange,
    this.invert = false,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _PreferencesSwitchWidgetState();
}

class _PreferencesSwitchWidgetState extends AbstractStatefulWidgetState<PreferencesSwitchWidget> {
  bool _value = false;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _value = widget.invert ? !(prefsInt(widget.prefsKey) == 1) : (prefsInt(widget.prefsKey) == 1);
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context)!;

    String? description = _value ? widget.descriptionOn : widget.descriptionOff;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: commonTheme.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.labelStyle),
              ),
            ),
            CommonSpaceH(),
            Switch(
              value: _value,
              onChanged: (bool newValue) {
                prefsSetInt(widget.prefsKey, (widget.invert ? !newValue : newValue) ? 1 : 0);

                setState(() {
                  _value = newValue;
                });

                final theOnChange = widget.onChange;

                if (theOnChange != null) {
                  theOnChange(newValue);
                }
              },
            ),
          ],
        ),
        if (description != null)
          Text(
            description,
            style: commonTheme.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.descriptionStyle),
          ),
        CommonSpaceV(),
      ],
    );
  }
}

class PreferencesSwitchStyle {
  final TextStyle labelStyle;
  final TextStyle descriptionStyle;

  /// PreferencesSwitchStyle initialization
  const PreferencesSwitchStyle({
    this.labelStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.descriptionStyle = const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
  });
}
