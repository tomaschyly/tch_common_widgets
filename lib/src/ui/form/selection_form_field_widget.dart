import 'package:collection/collection.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/boundary.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class SelectionFormFieldWidget<T> extends AbstractStatefulWidget {
  final SelectionFormFieldStyle? style;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? label;
  final String? selectionTitle;
  final String? clearText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final T? initialValue;
  final List<ListDialogOption<T>> options;
  final ValueChanged<T?>? onChange;
  final List<FormFieldValidation<T>>? validations;
  final bool hasFilter;
  final String? filterText;

  /// SelectionFormFieldWidget initialization
  SelectionFormFieldWidget({
    GlobalKey<SelectionFormFieldWidgetState>? key,
    this.style,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.selectionTitle,
    this.clearText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.options,
    this.onChange,
    this.validations,
    this.hasFilter = false,
    this.filterText,
  })  : assert(options.isNotEmpty),
        assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => SelectionFormFieldWidgetState<T>();
}

class SelectionFormFieldWidgetState<T>
    extends AbstractStatefulWidgetState<SelectionFormFieldWidget<T>> {
  T? get value => _value;

  final GlobalKey _fieldKey = GlobalKey();
  bool _isHovered = false;
  bool _selectingOption = false;
  FocusNode? _focusNode;
  late List<ListDialogOption<T>> _options;
  T? _value;
  final TextEditingController _controller = TextEditingController();
  Boundary? _fieldBoundary;
  String _errorText = '';

  /// State initialization
  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode;
    _focusNode ??= FocusNode();
    _focusNode!.addListener(_focusChanged);

    _options = widget.options;

    _value = widget.initialValue;
    if (_value != null) {
      final ListDialogOption<T>? option =
          _options.firstWhereOrNull((ListDialogOption<T> option) => option.value == _value);

      _controller.text = option?.text ?? '';
    }
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
  void didUpdateWidget(covariant SelectionFormFieldWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _focusNode!.removeListener(_focusChanged);
    _focusNode = widget.focusNode;
    _focusNode ??= FocusNode();
    _focusNode!.addListener(_focusChanged);

    if (oldWidget.options != widget.options) {
      _options = widget.options;

      final ListDialogOption<T>? option =
          _options.firstWhereOrNull((ListDialogOption<T> option) => option.value == _value);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.text = option?.text ?? '';
      });
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly =
        commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final baseInputStyle = widget.style?.inputStyle ??
        commonTheme?.formStyle.selectionFormFieldStyle.inputStyle ??
        const TextFormFieldStyle();

    final baseBorderRadius = widget.style?.borderRadius ??
        commonTheme?.formStyle.selectionFormFieldStyle.borderRadius;
    final baseMouseCursor =
        widget.style?.mouseCursor ??
        commonTheme?.formStyle.selectionFormFieldStyle.mouseCursor ??
        SystemMouseCursors.click;
    final hoverStyle =
        widget.style?.hoverStyle ??
        commonTheme?.formStyle.selectionFormFieldStyle.hoverStyle;
    final hoverInputStyle = hoverStyle?.inputStyle ?? baseInputStyle;
    final hoverBorderRadius = hoverStyle?.borderRadius ?? baseBorderRadius;
    final hoverMouseCursor = hoverStyle?.mouseCursor ?? baseMouseCursor;
    final animationDuration =
        widget.style?.animationDuration ??
        commonTheme?.formStyle.selectionFormFieldStyle.animationDuration ??
        kThemeAnimationDuration;
    final animationCurve =
        widget.style?.animationCurve ??
        commonTheme?.formStyle.selectionFormFieldStyle.animationCurve ??
        Curves.easeOut;

    final theBoundary = _fieldBoundary;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateHeight();
    });

    final theValidations = widget.validations;
    final isHoverActive = _isHovered && hoverStyle != null;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isHoverActive ? 1 : 0),
      duration: animationDuration,
      curve: animationCurve,
      builder: (BuildContext context, double hoverProgress, Widget? child) {
        final inputStyle = _interpolateInputStyle(
          baseInputStyle,
          hoverInputStyle,
          hoverProgress,
        );
        final borderRadius = BorderRadius.lerp(
          baseBorderRadius,
          hoverBorderRadius,
          hoverProgress,
        );
        final mouseCursor =
            hoverProgress < 0.5 ? baseMouseCursor : hoverMouseCursor;

        Widget? control;

        if (theBoundary != null) {
          control = Material(
            color: Colors.transparent,
            child: InkWell(
              mouseCursor: mouseCursor,
              onHover: _setHoverState,
              onTap: () {
                selectOption(context);
              },
              child: SizedBox(
                width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
                height: theBoundary.height,
              ),
            ),
          );

          if (borderRadius != null) {
            control = ClipRRect(
              borderRadius: borderRadius,
              child: control,
            );
          }
        }

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
                        final validated =
                            validateValidations(theValidations, _value);

                        _errorText = validated ?? '';

                        return validated == null;
                      },
                      errorText: '',
                      dynamicErrorText: () => _errorText,
                    ),
                ],
              ),
            ),
            ?control,
          ],
        );
      },
    );
  }

  /// Use TextFormFieldWidget height for InkWell height
  void _calculateHeight() {
    if (_fieldKey.currentContext != null && _fieldBoundary == null) {
      final RenderBox renderBox =
          _fieldKey.currentContext!.findRenderObject() as RenderBox;

      final boundary =
          Boundary(renderBox.size.width, renderBox.size.height, 0, 0);

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

      selectOption(context);
    }
  }

  /// Update hover state and rebuild only when value changes
  void _setHoverState(bool isHovered) {
    if (_isHovered == isHovered) {
      return;
    }

    setStateNotDisposed(() {
      _isHovered = isHovered;
    });
  }

  /// Interpolate TextFormFieldStyle for hover animation
  TextFormFieldStyle _interpolateInputStyle(
    TextFormFieldStyle fromStyle,
    TextFormFieldStyle toStyle,
    double progress,
  ) {
    return fromStyle.copyWith(
      inputStyle:
          TextStyle.lerp(fromStyle.inputStyle, toStyle.inputStyle, progress) ??
          (progress < 0.5 ? fromStyle.inputStyle : toStyle.inputStyle),
      disabledInputStyle:
          TextStyle.lerp(
            fromStyle.disabledInputStyle,
            toStyle.disabledInputStyle,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.disabledInputStyle
              : toStyle.disabledInputStyle),
      inputDecoration: _interpolateInputDecoration(
        fromStyle.inputDecoration,
        toStyle.inputDecoration,
        progress,
      ),
      borderColor:
          Color.lerp(fromStyle.borderColor, toStyle.borderColor, progress) ??
          (progress < 0.5 ? fromStyle.borderColor : toStyle.borderColor),
      fillColorDisabled:
          Color.lerp(
            fromStyle.fillColorDisabled,
            toStyle.fillColorDisabled,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.fillColorDisabled
              : toStyle.fillColorDisabled),
      disabledBorderColor:
          Color.lerp(
            fromStyle.disabledBorderColor,
            toStyle.disabledBorderColor,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.disabledBorderColor
              : toStyle.disabledBorderColor),
      focusedBorderColor:
          Color.lerp(
            fromStyle.focusedBorderColor,
            toStyle.focusedBorderColor,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.focusedBorderColor
              : toStyle.focusedBorderColor),
      errorColor: Color.lerp(fromStyle.errorColor, toStyle.errorColor, progress) ??
          (progress < 0.5 ? fromStyle.errorColor : toStyle.errorColor),
      cupertinoLabelPadding:
          EdgeInsets.lerp(
            fromStyle.cupertinoLabelPadding,
            toStyle.cupertinoLabelPadding,
            progress,
          ) ??
          (progress < 0.5
              ? fromStyle.cupertinoLabelPadding
              : toStyle.cupertinoLabelPadding),
    );
  }

  /// Interpolate InputDecoration for hover animation
  InputDecoration _interpolateInputDecoration(
    InputDecoration fromDecoration,
    InputDecoration toDecoration,
    double progress,
  ) {
    return fromDecoration.copyWith(
      isDense: progress < 0.5 ? fromDecoration.isDense : toDecoration.isDense,
      fillColor:
          Color.lerp(fromDecoration.fillColor, toDecoration.fillColor, progress),
      labelStyle: TextStyle.lerp(
        fromDecoration.labelStyle,
        toDecoration.labelStyle,
        progress,
      ),
      hintStyle: TextStyle.lerp(
        fromDecoration.hintStyle,
        toDecoration.hintStyle,
        progress,
      ),
      errorStyle: TextStyle.lerp(
        fromDecoration.errorStyle,
        toDecoration.errorStyle,
        progress,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        fromDecoration.contentPadding,
        toDecoration.contentPadding,
        progress,
      ),
      enabledBorder:
          progress < 0.5
              ? fromDecoration.enabledBorder
              : toDecoration.enabledBorder,
      disabledBorder:
          progress < 0.5
              ? fromDecoration.disabledBorder
              : toDecoration.disabledBorder,
      focusedBorder:
          progress < 0.5
              ? fromDecoration.focusedBorder
              : toDecoration.focusedBorder,
      errorBorder:
          progress < 0.5
              ? fromDecoration.errorBorder
              : toDecoration.errorBorder,
      focusedErrorBorder:
          progress < 0.5
              ? fromDecoration.focusedErrorBorder
              : toDecoration.focusedErrorBorder,
    );
  }

  /// Select option using ListDialog
  Future<void> selectOption(BuildContext context) async {
    if (_selectingOption) {
      return;
    }
    _selectingOption = true;

    FocusManager.instance.primaryFocus?.unfocus();
    final focusScope = FocusScope.of(context);

    for (final ListDialogOption option in _options) {
      option.isSelected = _value == option.value;
    }

    final T? newValue = await ListDialog.show(
      context,
      options: _options,
      title: widget.selectionTitle,
      cancelText: widget.clearText ?? 'Clear',
      hasFilter: widget.hasFilter,
      filterText: widget.filterText,
    );

    setStateNotDisposed(() {
      _value = newValue;

      final ListDialogOption<T>? option =
          _options.firstWhereOrNull((ListDialogOption<T> option) => option.value == _value);

      _controller.text = option?.text ?? '';
    });

    final theOnChange = widget.onChange;
    if (theOnChange != null) {
      theOnChange(newValue);
    }

    final theNextFocus = widget.nextFocus;
    if (newValue != null && theNextFocus != null) {
      focusScope.requestFocus(theNextFocus);
    }

    _selectingOption = false;
  }

  /// Set value to newValue if there is options for it
  void setValue(T? newValue) {
    final ListDialogOption<T>? option =
        _options.firstWhereOrNull((ListDialogOption<T> option) => option.value == newValue);

    if (newValue == null || option != null) {
      _controller.text = option?.text ?? '';

      setStateNotDisposed(() {
        _value = newValue;
      });
    }
  }
}

class SelectionFormFieldStyle {
  final TextFormFieldStyle inputStyle;
  final BorderRadius? borderRadius;
  final SelectionFormFieldHoverStyle? hoverStyle;
  final MouseCursor mouseCursor;
  final Duration animationDuration;
  final Curve animationCurve;

  /// SelectionFormFieldStyle initialization
  const SelectionFormFieldStyle({
    this.inputStyle = const TextFormFieldStyle(),
    this.borderRadius = const BorderRadius.all(.circular(8)),
    this.hoverStyle,
    this.mouseCursor = SystemMouseCursors.click,
    this.animationDuration = kThemeAnimationDuration,
    this.animationCurve = Curves.easeOut,
  });

  /// Create copy of this style with changes
  SelectionFormFieldStyle copyWith({
    TextFormFieldStyle? inputStyle,
    BorderRadius? borderRadius,
    SelectionFormFieldHoverStyle? hoverStyle,
    MouseCursor? mouseCursor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return SelectionFormFieldStyle(
      inputStyle: inputStyle ?? this.inputStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      hoverStyle: hoverStyle ?? this.hoverStyle,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

class SelectionFormFieldHoverStyle {
  final TextFormFieldStyle? inputStyle;
  final BorderRadius? borderRadius;
  final MouseCursor? mouseCursor;

  /// SelectionFormFieldHoverStyle initialization
  const SelectionFormFieldHoverStyle({
    this.inputStyle,
    this.borderRadius,
    this.mouseCursor,
  });

  /// Create copy of this hover style with changes
  SelectionFormFieldHoverStyle copyWith({
    TextFormFieldStyle? inputStyle,
    BorderRadius? borderRadius,
    MouseCursor? mouseCursor,
  }) {
    return SelectionFormFieldHoverStyle(
      inputStyle: inputStyle ?? this.inputStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }
}
