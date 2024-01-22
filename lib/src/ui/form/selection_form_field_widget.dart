import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/boundary.dart';
import 'package:tch_appliable_core/utils/form.dart';
import 'package:tch_appliable_core/utils/list.dart';
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
  })  : assert(options.isNotEmpty),
        assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => SelectionFormFieldWidgetState<T>();
}

class SelectionFormFieldWidgetState<T> extends AbstractStatefulWidgetState<SelectionFormFieldWidget<T>> {
  T? get value => _value;

  final GlobalKey _fieldKey = GlobalKey();
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
    if (_focusNode == null) {
      _focusNode = FocusNode();
    }
    _focusNode!.addListener(_focusChanged);

    _options = widget.options;

    _value = widget.initialValue;
    if (_value != null) {
      final ListDialogOption? option = _options.firstWhereOrNull((ListDialogOption option) => option.value == _value);

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
    if (_focusNode == null) {
      _focusNode = FocusNode();
    }
    _focusNode!.addListener(_focusChanged);

    if (oldWidget.options != widget.options) {
      _options = widget.options;

      final ListDialogOption? option = _options.firstWhereOrNull((ListDialogOption option) => option.value == _value);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.text = option?.text ?? '';
      });
    }
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final inputStyle = widget.style?.inputStyle ?? commonTheme?.formStyle.selectionFormFieldStyle.inputStyle ?? const TextFormFieldStyle();

    final borderRadius = widget.style?.borderRadius ?? commonTheme?.formStyle.selectionFormFieldStyle.borderRadius;

    final theBoundary = _fieldBoundary;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateHeight();
    });

    Widget? control;

    if (theBoundary != null) {
      control = Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity,
            height: theBoundary.height,
          ),
          onTap: () {
            selectOption(context);
          },
        ),
      );

      if (borderRadius != null) {
        control = ClipRRect(
          borderRadius: borderRadius,
          child: control,
        );
      }
    }

    final theValidations = widget.validations;

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
                    final validated = validateValidations(theValidations, _value);

                    _errorText = validated ?? '';

                    return validated == null;
                  },
                  errorText: '',
                  dynamicErrorText: () => _errorText,
                ),
            ],
          ),
        ),
        if (control != null) control,
      ],
    );
  }

  /// Use TextFormFieldWidget height for InkWell height
  void _calculateHeight() {
    if (_fieldKey.currentContext != null && _fieldBoundary == null) {
      final RenderBox renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;

      final boundary = Boundary(renderBox.size.width, renderBox.size.height, 0, 0);

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

  /// Select option using ListDialog
  Future<void> selectOption(BuildContext context) async {
    if (_selectingOption) {
      return;
    }
    _selectingOption = true;

    clearFocus(context);

    _options.forEach((ListDialogOption option) {
      option.isSelected = _value == option.value;
    });

    final T? newValue = await ListDialog.show(
      context,
      options: _options,
      title: widget.selectionTitle,
      cancelText: widget.clearText ?? 'Clear',
    );

    setStateNotDisposed(() {
      _value = newValue;

      final ListDialogOption? option = _options.firstWhereOrNull((ListDialogOption option) => option.value == _value);

      _controller.text = option?.text ?? '';
    });

    final theOnChange = widget.onChange;
    if (theOnChange != null) {
      theOnChange(newValue);
    }

    final theNextFocus = widget.nextFocus;
    if (newValue != null && theNextFocus != null) {
      FocusScope.of(context).requestFocus(theNextFocus);
    }

    _selectingOption = false;
  }

  /// Set value to newValue if there is options for it
  void setValue(T? newValue) {
    final ListDialogOption? option = _options.firstWhereOrNull((ListDialogOption option) => option.value == newValue);

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

  /// SelectionFormFieldStyle initialization
  const SelectionFormFieldStyle({
    this.inputStyle = const TextFormFieldStyle(),
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
  });

  /// Create copy of this style with changes
  SelectionFormFieldStyle copyWith({
    TextFormFieldStyle? inputStyle,
    BorderRadius? borderRadius,
  }) {
    return SelectionFormFieldStyle(
      inputStyle: inputStyle ?? this.inputStyle,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
