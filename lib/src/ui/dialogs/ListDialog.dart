import 'dart:async';

import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class ListDialog<T> extends AbstractStatefulWidget {
  final ListDialogStyle? style;
  final String? title;
  final String? cancelText;
  final String? confirmText;
  final List<ListDialogOption<T>> options;
  final bool hasFilter;
  final String? filterText;
  final SelectionFormFieldCustomOption? customOption;
  final Function(BuildContext context)? onConfirmTap;
  final ValueNotifier<bool>? customOptionFocusChangeNotifier;
  final TextEditingController? customOptionTextController;
  final FocusNode? customOptionFocusNode;

  /// ListDialog initialization
  ListDialog({
    this.style,
    this.title,
    this.cancelText,
    this.confirmText,
    required this.options,
    this.hasFilter = false,
    this.filterText,
    this.customOption,
    this.onConfirmTap,
    this.customOptionFocusChangeNotifier,
    this.customOptionFocusNode,
    this.customOptionTextController
  }) : assert(options.isNotEmpty);

  /// Show the dialog as a popup
  static Future<T?> show<T>(BuildContext context, {
    ListDialogStyle? style,
    String? title,
    String? cancelText,
    String? confirmText,
    required List<ListDialogOption<T>> options,
    bool hasFilter = false,
    String? filterText,
    SelectionFormFieldCustomOption? customOption,
    Function(BuildContext context)? onConfirmTap,
    ValueNotifier<bool>? customOptionFocusChangeNotifier,
    TextEditingController? customOptionTextController,
    FocusNode? customOptionFocusNode,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ListDialog<T>(
            style: style,
            title: title,
            cancelText: cancelText,
            confirmText: confirmText,
            options: options,
            customOption: customOption,
            hasFilter: hasFilter,
            filterText: filterText,
            onConfirmTap: onConfirmTap,
            customOptionFocusChangeNotifier: customOptionFocusChangeNotifier,
            customOptionFocusNode: customOptionFocusNode,
            customOptionTextController: customOptionTextController,
          ),
        );
      },
    );
  }

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _ListDialogState<T>();
}

class _ListDialogState<T> extends AbstractStatefulWidgetState<ListDialog<T>> {
  final ScrollController _scrollController = ScrollController();
  List<ListDialogOption<T>> _options = [];
  final TextEditingController _filterController = TextEditingController();
  Timer? _filterTimer;
  final GlobalKey customOptionFieldKey = GlobalKey();

  /// State initialization
  @override
  void initState() {
    super.initState();
    widget.customOptionFocusChangeNotifier?.addListener(_onCustomOptionFocused);

    _options = widget.options;

    if (widget.hasFilter) {
      _filterController.addListener(_filterOptions);
    }
  }

  /// Manually dispose of resources
  @override
  void dispose() {
    _filterTimer?.cancel();
    _filterTimer = null;

    if (widget.hasFilter) {
      _filterController.removeListener(_filterOptions);
    }

    widget.customOptionFocusChangeNotifier?.removeListener(_onCustomOptionFocused);

    _scrollController.dispose();
    _filterController.dispose();

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final dialogContainerStyle =
        widget.style?.dialogContainerStyle ?? commonTheme?.dialogsStyle.listDialogStyle.dialogContainerStyle ?? const DialogContainerStyle();
    final dialogHeaderStyle = widget.style?.dialogHeaderStyle ?? commonTheme?.dialogsStyle.listDialogStyle.dialogHeaderStyle ?? const DialogHeaderStyle();
    final dialogFooterStyle = widget.style?.dialogFooterStyle ?? commonTheme?.dialogsStyle.listDialogStyle.dialogFooterStyle ?? const DialogFooterStyle();

    final theTitle = widget.title;

    final filterStyle = widget.style?.filterStyle ?? commonTheme?.dialogsStyle.listDialogStyle.filterStyle ?? const TextFormFieldStyle();

    final customOptionStyle = widget.customOption?.style ?? commonTheme?.formStyle.textFormFieldStyle ?? const TextFormFieldStyle();

    final optionHeight = widget.style?.optionStyle.height ?? commonTheme?.dialogsStyle.listDialogStyle.optionStyle.height ?? kMinInteractiveSize;
    final optionStyle = widget.style?.optionStyle ?? commonTheme?.dialogsStyle.listDialogStyle.optionStyle ?? const CommonButtonStyle();
    final optionsSpacing = widget.style?.optionsSpacing ?? commonTheme?.dialogsStyle.listDialogStyle.optionsSpacing ?? kCommonVerticalMarginQuarter;
    final selectedOptionStyle = widget.style?.selectedOptionStyle ??
        commonTheme?.dialogsStyle.listDialogStyle.selectedOptionStyle ??
        const CommonButtonStyle(
          variant: ButtonVariant.Filled,
        );

    return DialogContainer(
      style: dialogContainerStyle,
      contentBeforeScroll: [
        if (theTitle != null) ...[
          DialogHeader(
            style: dialogHeaderStyle,
            title: theTitle,
          ),
        ],
        if (theTitle != null && widget.hasFilter) CommonSpaceVHalf(),
        if (widget.hasFilter) ...[
          TextFormFieldWidget(
            style: filterStyle,
            controller: _filterController,
            label: widget.filterText ?? 'Filter Options',
          ),
        ],
      ],
      content: [
        if (theTitle != null || widget.hasFilter) CommonSpaceVHalf(),
        Flexible(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double optionsHeight = ((_options.length * optionHeight) + ((_options.length - 1) * optionsSpacing)).toDouble() +
                  (widget.customOption != null ? optionsSpacing + optionHeight : 0);
              optionsHeight = optionsHeight > 0 ? optionsHeight : 0;

              return Container(
                height: optionsHeight < constraints.maxHeight ? optionsHeight : constraints.maxHeight,
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._options.map((ListDialogOption option) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: option == _options.last ? 0 : optionsSpacing),
                              child: ButtonWidget(
                                style: option.isSelected ? selectedOptionStyle : optionStyle,
                                text: option.text,
                                onTap: !option.isSelected
                                    ? () {
                                  Navigator.pop(context, option.value);
                                }
                                    : null,
                              ),
                            );
                          }).toList(),
                          if(widget.customOption != null && widget.customOptionTextController != null)
                            Padding(
                              padding: EdgeInsets.only(top: optionsSpacing, bottom: 150),
                              child: SizedBox(
                                  height: optionHeight,
                                  child: TextFormFieldWidget(
                                    key: customOptionFieldKey,
                                    style: customOptionStyle,
                                    controller: widget.customOptionTextController!,
                                    focusNode: widget.customOptionFocusNode,
                                  )
                              ),
                            ),
                        ]
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        CommonSpaceVHalf(),
      ],
      dialogFooter: DialogFooter(
        style: dialogFooterStyle,
        noText: widget.cancelText ?? 'Cancel',
        yesText: widget.confirmText,
        yesOnTap: () {
          if (widget.onConfirmTap != null) {
            widget.onConfirmTap!(context);
          }
        },
        noOnTap: () {
          Navigator.pop(context, null);
        },
      ),
    );
  }

  void _onCustomOptionFocused() {
    if (widget.customOptionFocusChangeNotifier?.value == true) {
      _options.forEach((element) {
        element.isSelected = false;
      });
      Scrollable.ensureVisible(customOptionFieldKey.currentContext!);
      setStateNotDisposed(() {});
    }
  }

  /// Filter options by term
  void _filterOptions() {
    _filterTimer?.cancel();

    _filterTimer = Timer(
      Duration(milliseconds: 300),
          () {
        final String term = _filterController.text.trim().toLowerCase();

        setStateNotDisposed(() {
          _options = widget.options.where((option) => option.text.toLowerCase().contains(term)).toList();
        });
      },
    );
  }
}

class ListDialogStyle {
  final DialogContainerStyle dialogContainerStyle;
  final DialogHeaderStyle dialogHeaderStyle;
  final DialogFooterStyle dialogFooterStyle;
  final TextFormFieldStyle filterStyle;
  final CommonButtonStyle optionStyle;
  final CommonButtonStyle selectedOptionStyle;
  final double optionsSpacing;

  /// ListDialogStyle initialization
  const ListDialogStyle({
    this.dialogContainerStyle = const DialogContainerStyle(),
    this.dialogHeaderStyle = const DialogHeaderStyle(),
    this.dialogFooterStyle = const DialogFooterStyle(),
    this.filterStyle = const TextFormFieldStyle(),
    this.optionStyle = const CommonButtonStyle(
      variant: ButtonVariant.TextOnly,
    ),
    this.selectedOptionStyle = const CommonButtonStyle(
      variant: ButtonVariant.Filled,
    ),
    this.optionsSpacing = kCommonVerticalMarginQuarter,
  });

  /// Create copy of this tyle with changes
  ListDialogStyle copyWith({
    DialogContainerStyle? dialogContainerStyle,
    DialogHeaderStyle? dialogHeaderStyle,
    DialogFooterStyle? dialogFooterStyle,
    TextFormFieldStyle? filterStyle,
    CommonButtonStyle? optionStyle,
    CommonButtonStyle? selectedOptionStyle,
    double? optionsSpacing,
  }) {
    return ListDialogStyle(
      dialogContainerStyle: dialogContainerStyle ?? this.dialogContainerStyle,
      dialogHeaderStyle: dialogHeaderStyle ?? this.dialogHeaderStyle,
      dialogFooterStyle: dialogFooterStyle ?? this.dialogFooterStyle,
      filterStyle: filterStyle ?? this.filterStyle,
      optionStyle: optionStyle ?? this.optionStyle,
      selectedOptionStyle: selectedOptionStyle ?? this.selectedOptionStyle,
      optionsSpacing: optionsSpacing ?? this.optionsSpacing,
    );
  }
}

class ListDialogOption<T> {
  final String text;
  final T value;
  bool isSelected;

  /// ListDialogOption initialization
  ListDialogOption({
    required this.text,
    required this.value,
    this.isSelected = false,
  });
}