import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_common_widgets/tch_common_widgets.dart';

class DialogContainer extends AbstractStatefulWidget {
  final DialogContainerStyle style;
  final bool isScrollable;
  final List<Widget>? contentBeforeScroll;
  final List<Widget> content;
  final DialogFooter dialogFooter;

  /// DialogContainer initialization
  DialogContainer({
    required this.style,
    this.isScrollable = true,
    this.contentBeforeScroll,
    required this.content,
    required this.dialogFooter,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _DialogContainerState();
}

class _DialogContainerState extends AbstractStatefulWidgetState<DialogContainer> {
  final ScrollController _scrollController = ScrollController();

  /// Manually dispose of resources
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = CommonTheme.of(context);

    final bool fullWidthMobileOnly = commonTheme?.dialogsStyle.fullWidthMobileOnly ?? true;
    final double dialogWidth =
        widget.style.dialogWidth ?? commonTheme?.dialogsStyle.dialogWidth ?? (fullWidthMobileOnly ? kPhoneStopBreakpoint : double.infinity);

    final borderRadius = widget.style.borderRadius;

    final theContentBeforeScroll = widget.contentBeforeScroll;

    Widget dialog;

    if (widget.isScrollable) {
      dialog = Container(
        width: dialogWidth,
        margin: widget.style.dialogMargin,
        decoration: BoxDecoration(
          color: widget.style.backgroundColor,
          border: Border.all(
            color: widget.style.color,
            width: 1,
          ),
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (theContentBeforeScroll != null)
              Container(
                padding: widget.style.dialogPadding.copyWith(
                  bottom: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: theContentBeforeScroll,
                ),
              ),
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    padding: widget.style.dialogPadding.copyWith(
                      top: theContentBeforeScroll != null ? 0 : null,
                      bottom: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.content,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: widget.style.dialogPadding.copyWith(
                top: 0,
              ),
              child: widget.dialogFooter,
            ),
          ],
        ),
      );
    } else {
      dialog = Container(
        width: dialogWidth,
        padding: widget.style.dialogPadding,
        margin: widget.style.dialogMargin,
        decoration: BoxDecoration(
          color: widget.style.backgroundColor,
          border: Border.all(
            color: widget.style.color,
            width: 1,
          ),
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (theContentBeforeScroll != null) ...theContentBeforeScroll,
            ...widget.content,
            widget.dialogFooter,
          ],
        ),
      );
    }

    if (borderRadius != null) {
      dialog = ClipRRect(
        borderRadius: borderRadius,
        child: dialog,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: widget.style.mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: dialog,
        ),
      ],
    );
  }
}

class DialogContainerStyle {
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets dialogPadding;
  final EdgeInsets dialogMargin;
  final double? dialogWidth;
  final Color color;
  final Color backgroundColor;
  final BorderRadius? borderRadius;

  /// DialogContainerStyle initialization
  const DialogContainerStyle({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.dialogPadding = const EdgeInsets.all(12),
    this.dialogMargin = const EdgeInsets.all(kCommonPrimaryMargin),
    this.dialogWidth,
    this.color = Colors.transparent,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
  });

  /// Create copy of this tyle with changes
  DialogContainerStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? dialogPadding,
    EdgeInsets? dialogMargin,
    double? dialogWidth,
    Color? color,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return DialogContainerStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      dialogMargin: dialogMargin ?? this.dialogMargin,
      dialogWidth: dialogWidth ?? this.dialogWidth,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
