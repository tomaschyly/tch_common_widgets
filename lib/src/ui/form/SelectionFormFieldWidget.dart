import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/Boundary.dart';
import 'package:tch_appliable_core/utils/List.dart';
import 'package:tch_appliable_core/utils/form.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';
import 'package:tch_common_widgets/src/ui/dialogs/ListDialog.dart';
import 'package:tch_common_widgets/src/ui/form/Form.dart';
import 'package:tch_common_widgets/src/ui/form/TextFormFieldWidget.dart';

class SelectionFormFieldWidget<T> extends AbstractStatefulWidget {
  final SelectionFormFieldStyle? style;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String? label;
  final String? selectionTitle;
  final String? clearText;
  final String? confirmText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final T? initialValue;
  final List<ListDialogOption<T>> options;
  final ValueChanged<T?>? onChange;
  final List<FormFieldValidation<T>>? validations;
  final SelectionFormFieldCustomOption? customOption;

  /// SelectionFormFieldWidget initialization
  SelectionFormFieldWidget({
    GlobalKey<SelectionFormFieldWidgetState>? key,
    this.style,
    this.focusNode,
    this.nextFocus,
    this.label,
    this.selectionTitle,
    this.clearText,
    this.confirmText,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    required this.options,
    this.onChange,
    this.validations,
    this.customOption,
  })
      : assert(options.isNotEmpty),
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
  final TextEditingController _customOptionTextController = TextEditingController();
  final FocusNode _customOptionFocusNode = FocusNode();
  Boundary? _fieldBoundary;
  String _errorText = '';
  final ValueNotifier<bool> customOptionFocusChangeNotifier = ValueNotifier<bool>(false);

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

    _customOptionTextController.addListener(_customOptionChange);
    _customOptionFocusNode.addListener(_customOptionFocused);
  }

  /// Dispose of resources manually
  @override
  void dispose() {
    _controller.dispose();
    _customOptionTextController.dispose();
    _customOptionFocusNode.dispose();
    customOptionFocusChangeNotifier.dispose();

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
        _controller.text = option?.text ?? _customOptionTextController.text;
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
            iOSUseNativeTextField: false,
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
    if (_customOptionFocusNode.hasFocus) {
      _customOptionFocusNode.unfocus();
    }

    if (_focusNode!.hasFocus) {
      _focusNode!.unfocus();

      selectOption(context);
    }
  }

  /// On custom option focus
  void _customOptionFocused() {
    _controller.text = _customOptionTextController.text;
    _value = _controller.text as T;

    if (_focusNode!.hasFocus) {
      _focusNode!.unfocus();

      selectOption(context);
    }
    customOptionFocusChangeNotifier.value = _customOptionFocusNode.hasFocus;
  }

  /// On custom option change
  void _customOptionChange() {
    _controller.text = _customOptionTextController.text;
    _value = _controller.text as T;

    final theOnChange = widget.onChange;

    if (theOnChange != null) {
      theOnChange(_value);
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
      customOption: widget.customOption,
      customOptionTextController: _customOptionTextController,
      customOptionFocusNode: _customOptionFocusNode,
      cancelText: widget.clearText ?? 'Clear',
      customOptionFocusChangeNotifier: customOptionFocusChangeNotifier,
      confirmText: widget.confirmText,
      onConfirmTap: widget.customOption == null ? null : (buildContext) =>
          Navigator.pop(buildContext, _customOptionTextController.text != '' ? _customOptionTextController.text : null),
    );

    setStateNotDisposed(() {
      _value = newValue;

      final ListDialogOption? option = _options.firstWhereOrNull((ListDialogOption option) => option.value == _value);

      _controller.text = option?.text ?? _customOptionTextController.text;
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

class SelectionFormFieldCustomOption {
  final bool show;
  final TextFormFieldStyle? style;

  SelectionFormFieldCustomOption({this.show = false, this.style});
}
