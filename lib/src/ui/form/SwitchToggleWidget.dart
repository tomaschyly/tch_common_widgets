import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/buttons/IconButtonWidget.dart';

class SwitchToggleWidget extends AbstractStatefulWidget {
  final SwitchToggleWidgetStyle? style;
  final ValueChanged<bool>? onChange;
  final bool initialValue;
  final String? onText;
  final String? offText;

  /// SwitchToggleWidget initialization
  SwitchToggleWidget({
    this.style,
    this.onChange,
    this.initialValue = false,
    this.onText,
    this.offText,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _SwitchToggleWidgetState();
}

class _SwitchToggleWidgetState extends AbstractStatefulWidgetState<SwitchToggleWidget> {
  bool _value = false;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final IconButtonStyle iconButtonStyle =
        (widget.style?.iconButtonStyle ?? commonTheme?.formStyle.switchToggleWidgetStyle.iconButtonStyle) ?? const IconButtonStyle();
    final String? onSvgAssetPath = widget.style?.onSvgAssetPath ?? commonTheme?.formStyle.switchToggleWidgetStyle.onSvgAssetPath;
    final String? offSvgAssetPath = widget.style?.offSvgAssetPath ?? commonTheme?.formStyle.switchToggleWidgetStyle.offSvgAssetPath;

    final Widget? onIconWidget = widget.style?.onIconWidget ?? commonTheme?.formStyle.switchToggleWidgetStyle.onIconWidget;
    final Widget? offIconWidget = widget.style?.offIconWidget ?? commonTheme?.formStyle.switchToggleWidgetStyle.offIconWidget;

    final bool useText = widget.style?.useText ?? commonTheme?.formStyle.switchToggleWidgetStyle.useText ?? false;

    String? svgAssetPath;
    Widget? iconWidget;

    if (useText) {
      TextStyle? textStyle = widget.style?.textStyle ?? commonTheme?.formStyle.switchToggleWidgetStyle.textStyle;
      if (textStyle != null && commonTheme != null) {
        textStyle = commonTheme.preProcessTextStyle(textStyle);
      }

      final String onText = (widget.style?.onText ?? commonTheme?.formStyle.switchToggleWidgetStyle.onText) ?? 'On';
      final String offText = (widget.style?.offText ?? commonTheme?.formStyle.switchToggleWidgetStyle.offText) ?? 'Off';

      iconWidget = Text(
        _value ? onText : offText,
        style: textStyle,
        textAlign: TextAlign.center,
      );
    } else if (onSvgAssetPath != null && offSvgAssetPath != null) {
      svgAssetPath = _value ? onSvgAssetPath : offSvgAssetPath;
    } else {
      iconWidget = _value ? onIconWidget : offIconWidget;
    }

    return IconButtonWidget(
      style: iconButtonStyle,
      svgAssetPath: svgAssetPath,
      iconWidget: iconWidget,
      onTap: () {
        _value = !_value;

        setStateNotDisposed(() {});

        final theOnChange = widget.onChange;

        if (theOnChange != null) {
          theOnChange(_value);
        }
      },
    );
  }
}

class SwitchToggleWidgetStyle {
  final IconButtonStyle iconButtonStyle;
  final String? onSvgAssetPath;
  final String? offSvgAssetPath;
  final Widget? onIconWidget;
  final Widget? offIconWidget;
  final bool useText;
  final TextStyle textStyle;
  final String? onText;
  final String? offText;

  /// SwitchToggleWidgetStyle initialization
  const SwitchToggleWidgetStyle({
    this.iconButtonStyle = const IconButtonStyle(iconRestricted: false),
    this.onSvgAssetPath,
    this.offSvgAssetPath,
    this.onIconWidget,
    this.offIconWidget,
    this.useText = false,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.onText,
    this.offText,
  }) : assert((onSvgAssetPath != null && offSvgAssetPath != null) || (onIconWidget != null && offIconWidget != null) || useText);

  /// Create copy if this style with changes
  SwitchToggleWidgetStyle copyWith({
    IconButtonStyle? iconButtonStyle,
    String? onSvgAssetPath,
    String? offSvgAssetPath,
    Widget? onIconWidget,
    Widget? offIconWidget,
    bool? useText,
    TextStyle? textStyle,
    String? onText,
    String? offText,
  }) {
    return SwitchToggleWidgetStyle(
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
      onSvgAssetPath: onSvgAssetPath ?? this.onSvgAssetPath,
      offSvgAssetPath: offSvgAssetPath ?? this.offSvgAssetPath,
      onIconWidget: onIconWidget ?? this.onIconWidget,
      offIconWidget: offIconWidget ?? this.offIconWidget,
      useText: useText ?? this.useText,
      textStyle: textStyle ?? this.textStyle,
      onText: onText ?? this.onText,
      offText: offText ?? this.offText,
    );
  }
}
