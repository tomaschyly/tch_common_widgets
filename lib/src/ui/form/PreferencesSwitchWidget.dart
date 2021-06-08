import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/widgets/CommonSpace.dart';

class PreferencesSwitchWidget extends AbstractStatefulWidget {
  final PreferencesSwitchStyle? style;
  final String label;
  final String prefsKey;
  final String? descriptionOn;
  final String? descriptionOff;
  final ValueChanged<bool>? onChange;
  final bool invert;

  /// PreferencesSwitchWidget initialization
  PreferencesSwitchWidget({
    this.style,
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

class _PreferencesSwitchWidgetState extends AbstractStatefulWidgetState<PreferencesSwitchWidget> with SingleTickerProviderStateMixin {
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
    final commonTheme = CommonTheme.of(context);
    final bool animatedSizeChanges = commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    String? description = _value ? widget.descriptionOn : widget.descriptionOff;

    final Widget field = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.style?.crossAxisAlignment ?? commonTheme?.formStyle.preferencesSwitchStyle.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: widget.style?.labelStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.labelStyle),
              ),
            ),
            CommonSpaceH(),
            Switch(
              value: _value,
              onChanged: (bool newValue) {
                prefsSetInt(widget.prefsKey, (widget.invert ? !newValue : newValue) ? 1 : 0);

                setStateNotDisposed(() {
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
            style: widget.style?.descriptionStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.descriptionStyle),
          ),
        CommonSpaceV(),
      ],
    );

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
}

class PreferencesSwitchStyle {
  final TextStyle labelStyle;
  final TextStyle descriptionStyle;
  final CrossAxisAlignment crossAxisAlignment;

  /// PreferencesSwitchStyle initialization
  const PreferencesSwitchStyle({
    this.labelStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.descriptionStyle = const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Create copy of this style with changes
  PreferencesSwitchStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    return PreferencesSwitchStyle(
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }
}
