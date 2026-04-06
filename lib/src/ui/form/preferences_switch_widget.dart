import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class PreferencesSwitchWidget extends AbstractStatefulWidget {
  final PreferencesSwitchStyle? style;
  final String label;
  final String prefsKey;
  final String? descriptionOn;
  final String? descriptionOff;
  final ValueChanged<bool>? onChange;
  final bool invert;
  final String? onText;
  final String? offText;

  /// PreferencesSwitchWidget initialization
  const PreferencesSwitchWidget({
    super.key,
    this.style,
    required this.label,
    required this.prefsKey,
    this.descriptionOn,
    this.descriptionOff,
    this.onChange,
    this.invert = false,
    this.onText,
    this.offText,
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
    final theme = Theme.of(context);
    final commonTheme = CommonTheme.of(context);
    final bool animatedSizeChanges = commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final PreferencesSwitchLayout layout =
        (widget.style?.layout ?? commonTheme?.formStyle.preferencesSwitchStyle.layout) ??
        .horizontal;
    final bool useSwitchToggleWidget = (widget.style?.useSwitchToggleWidget ?? commonTheme?.formStyle.preferencesSwitchStyle.useSwitchToggleWidget) ?? false;

    String? description = _value ? widget.descriptionOn : widget.descriptionOff;

    List<Widget> mainWidgets = [
      if (layout == PreferencesSwitchLayout.horizontal)
        Expanded(
          child: Text(
            widget.label,
            style: widget.style?.labelStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.labelStyle),
          ),
        )
      else
        Text(
          widget.label,
          style: widget.style?.labelStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.preferencesSwitchStyle.labelStyle),
        ),
      if (layout == PreferencesSwitchLayout.horizontal) CommonSpaceH(),
      if (useSwitchToggleWidget) ...[
        if (layout == PreferencesSwitchLayout.vertical) CommonSpaceVHalf(),
        SwitchToggleWidget(
          onText: widget.onText,
          offText: widget.offText,
          onChange: _onChange,
          initialValue: _value,
        ),
        if (layout == PreferencesSwitchLayout.vertical) CommonSpaceVHalf(),
      ] else
        Switch(
          value: _value,
          onChanged: _onChange,
          activeThumbColor: theme.colorScheme.secondary,
        ),
    ];

    final Widget field = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.style?.crossAxisAlignment ?? commonTheme?.formStyle.preferencesSwitchStyle.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        if (layout == PreferencesSwitchLayout.horizontal)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: mainWidgets,
          )
        else
          ...mainWidgets,
        if (useSwitchToggleWidget && layout == PreferencesSwitchLayout.horizontal) CommonSpaceVHalf(),
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
      content = SizedBox(
        width: kPhoneStopBreakpoint,
        child: content,
      );
    }

    if (animatedSizeChanges) {
      content = AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.topCenter,
        child: content,
      );
    }

    return content;
  }

  /// On user toggle value, set prefs for key and send to callback
  void _onChange(bool newValue) {
    prefsSetInt(widget.prefsKey, (widget.invert ? !newValue : newValue) ? 1 : 0);

    setStateNotDisposed(() {
      _value = newValue;
    });

    final theOnChange = widget.onChange;

    if (theOnChange != null) {
      theOnChange(newValue);
    }
  }
}

class PreferencesSwitchStyle {
  final PreferencesSwitchLayout layout;
  final TextStyle labelStyle;
  final TextStyle descriptionStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final bool useSwitchToggleWidget;

  /// PreferencesSwitchStyle initialization
  const PreferencesSwitchStyle({
    this.layout = .horizontal,
    this.labelStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.descriptionStyle = const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
    this.crossAxisAlignment = .start,
    this.useSwitchToggleWidget = false,
  });

  /// Create copy of this style with changes
  PreferencesSwitchStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    CrossAxisAlignment? crossAxisAlignment,
    bool? useSwitchToggleWidget,
  }) {
    return PreferencesSwitchStyle(
      labelStyle: labelStyle ?? this.labelStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      useSwitchToggleWidget: useSwitchToggleWidget ?? this.useSwitchToggleWidget,
    );
  }
}

enum PreferencesSwitchLayout {
  none,
  horizontal,
  vertical,
}
