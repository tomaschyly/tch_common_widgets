import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/src/core/CommonDimens.dart';
import 'package:tch_common_widgets/src/core/CommonTheme.dart';

class TextFormFieldWidget extends AbstractStatefulWidget {
  final TextFormFieldStyle? style;
  final TextEditingController controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? label;
  final int lines;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autocorrect;

  /// TextFormFieldWidget initialization
  TextFormFieldWidget({
    this.style,
    Key? key,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.label,
    this.lines = 1,
    this.validator,
    this.enabled = true,
    this.autocorrect = true,
  })  : assert((focusNode == null && nextFocus == null) || focusNode != null),
        super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends AbstractStatefulWidgetState<TextFormFieldWidget> with SingleTickerProviderStateMixin {
  bool _isError = false;

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);
    final bool animatedSizeChanges = commonTheme?.formStyle.animatedSizeChanges ?? true;
    final bool fullWidthMobileOnly = commonTheme?.formStyle.fullWidthMobileOnly ?? true;

    final theNextFocus = widget.nextFocus;
    final theOnFieldSubmitted = widget.onFieldSubmitted;

    InputDecoration theDecoration = (widget.style?.inputDecoration ?? commonTheme?.formStyle.textFormFieldStyle.inputDecoration) ?? InputDecoration();

    if (commonTheme != null && widget.style?.inputDecoration == null) {
      theDecoration = theDecoration.copyWith(
        labelStyle: commonTheme.preProcessTextStyle(theDecoration.labelStyle!),
        enabledBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.enabledBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.enabledBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        disabledBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.disabledBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.disabledBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.disabledBorderColor,
          ),
        ),
        focusedBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.borderColor,
          ),
        ),
        errorBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.errorBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.errorBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        focusedErrorBorder: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedErrorBorder!.copyWith(
          borderSide: commonTheme.formStyle.textFormFieldStyle.inputDecoration.focusedErrorBorder!.borderSide.copyWith(
            color: commonTheme.formStyle.textFormFieldStyle.errorColor,
          ),
        ),
        errorStyle: commonTheme.preProcessTextStyle(theDecoration.errorStyle!).copyWith(
              color: commonTheme.formStyle.textFormFieldStyle.errorColor,
            ),
      );
    }

    if (!widget.enabled) {
      theDecoration = theDecoration.copyWith(
        fillColor: widget.style?.fillColorDisabled ?? commonTheme?.formStyle.textFormFieldStyle.fillColorDisabled,
      );
    }

    if (_isError) {
      theDecoration = theDecoration.copyWith(
        labelStyle: theDecoration.errorStyle?.copyWith(
          color: widget.style?.errorColor ?? commonTheme?.formStyle.textFormFieldStyle.errorColor,
        ),
      );
    }

    final Widget field = TextFormField(
      autofocus: widget.autofocus,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onFieldSubmitted: (String value) {
        if (theNextFocus != null) {
          widget.focusNode!.unfocus();

          theNextFocus.requestFocus();
        }

        if (theOnFieldSubmitted != null) {
          theOnFieldSubmitted(value);
        }
      },
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style?.inputStyle ?? commonTheme?.preProcessTextStyle(commonTheme.formStyle.textFormFieldStyle.inputStyle),
      decoration: theDecoration.copyWith(labelText: widget.label),
      textCapitalization: widget.textCapitalization,
      minLines: widget.lines,
      maxLines: widget.lines,
      validator: (String? value) {
        final theValidator = widget.validator;
        if (theValidator != null) {
          final validated = theValidator(value);

          setStateNotDisposed(() {
            _isError = validated != null;
          });

          return validated;
        }

        return null;
      },
      //TODO implement custom iOS fix for this!!!
      autocorrect: widget.autocorrect,
      enabled: widget.enabled,
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

class TextFormFieldStyle {
  final TextStyle inputStyle;
  final InputDecoration inputDecoration;
  final Color borderColor;
  final Color fillColorDisabled;
  final Color disabledBorderColor;
  final Color errorColor;

  /// TextFormFieldStyle initialization
  const TextFormFieldStyle({
    this.inputStyle = const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
    this.inputDecoration = const InputDecoration(
      isDense: true,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kCommonHorizontalMarginHalf,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
      ),
      errorStyle: const TextStyle(fontSize: 16),
    ),
    this.borderColor = Colors.black,
    this.fillColorDisabled = Colors.grey,
    this.disabledBorderColor = Colors.grey,
    this.errorColor = Colors.red,
  });
}
