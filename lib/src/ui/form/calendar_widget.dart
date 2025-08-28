import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/boundary.dart';
import 'package:tch_appliable_core/utils/date.dart';
import 'package:tch_appliable_core/utils/widget.dart';
import 'package:tch_common_widgets/src/core/common_theme.dart';
import 'package:tch_common_widgets/src/ui/buttons/icon_button_widget.dart';

class CalendarWidget extends AbstractStatefulWidget {
  final CalendarWidgetStyle? style;
  final bool singleSelection;
  final Jiffy? staticDate;
  final Jiffy initialDate;
  final Jiffy? controlledDate;
  final List<Jiffy> initialDates;
  final List<Jiffy>? controlledDates;
  final Jiffy? firstDate;
  final Jiffy? lastDate;
  final ValueChanged<Jiffy>? onTapDay;
  final ValueChanged<Jiffy>? onSelect;
  final ValueChanged<List<Jiffy>>? onSelectMultiple;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? footer;
  final List<Jiffy> daysWithCheckbox;

  /// CalendarWidget initialization
  CalendarWidget({
    super.key,
    this.style,
    this.singleSelection = true,
    this.staticDate,
    required this.initialDate,
    this.controlledDate,
    this.initialDates = const [],
    this.controlledDates,
    this.firstDate,
    this.lastDate,
    this.onTapDay,
    this.onSelect,
    this.onSelectMultiple,
    this.padding = const EdgeInsets.only(),
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.footer,
    this.daysWithCheckbox = const [],
  }) : assert(singleSelection || onSelectMultiple != null, 'onSelectMultiple must be provided for multiple selection');

  /// Create state from widget
  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends AbstractStatefulWidgetState<CalendarWidget> {
  Jiffy? _firstDate;
  Jiffy? _lastDate;
  late Jiffy _selectedDate;
  late List<Jiffy> _selectedDates;
  late Jiffy _displayedMonth;
  int _weekDayStart = 0;
  List<String> _weekdays = [];
  List<Jiffy> _daysInMonth = [];
  final _gridKey = GlobalKey();
  Boundary? _gridBoundary;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _firstDate = widget.firstDate?.startOf(Unit.day);
    _lastDate = widget.lastDate?.endOf(Unit.day);

    _selectedDate = widget.controlledDate ?? widget.initialDate;
    _selectedDates = widget.controlledDates ?? widget.initialDates;

    if (_firstDate != null && _selectedDate.isBefore(_firstDate!)) {
      _selectedDate = _firstDate!;
    }
    if (_lastDate != null && _selectedDate.isAfter(_lastDate!)) {
      _selectedDate = _lastDate!;
    }

    _displayedMonth = _selectedDate;
    if (!widget.singleSelection) {
      _displayedMonth = _selectedDates.isNotEmpty ? _selectedDates.first : _selectedDate;
    }
  }

  /// Widget parameters changed
  @override
  void didUpdateWidget(covariant CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool regenerate = false;

    if (widget.firstDate != oldWidget.firstDate) {
      _firstDate = widget.firstDate?.startOf(Unit.day);
      regenerate = true;
    }

    if (widget.lastDate != oldWidget.lastDate) {
      _lastDate = widget.lastDate?.endOf(Unit.day);
      regenerate = true;
    }

    if (widget.singleSelection && widget.controlledDate != null && widget.controlledDate != oldWidget.controlledDate) {
      _selectedDate = widget.controlledDate!;

      regenerate = true;
    }

    if (!widget.singleSelection && widget.controlledDates != null && widget.controlledDates != oldWidget.controlledDates) {
      _selectedDates = widget.controlledDates!;

      regenerate = true;
    }

    if (widget.singleSelection && _firstDate != null && _selectedDate.isBefore(_firstDate!)) {
      _selectedDate = _firstDate!;

      regenerate = true;
    }
    if (widget.singleSelection && _lastDate != null && _selectedDate.isAfter(_lastDate!)) {
      _selectedDate = _lastDate!;

      regenerate = true;
    }

    if (!widget.singleSelection && (_firstDate != null || _lastDate != null)) {
      _selectedDates = _selectedDates.where((Jiffy selectedDay) {
        if (_firstDate != null && selectedDay.isBefore(_firstDate!)) {
          return false;
        }
        if (_lastDate != null && selectedDay.isAfter(_lastDate!)) {
          return false;
        }

        return true;
      }).toList();

      regenerate = true;
    }

    if (regenerate) {
      _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);
    }
  }

  /// Run initializations of view on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    final commonTheme = context.commonThemeOrNull;

    final weekDayStart = widget.style?.weekDayStart ?? commonTheme?.formStyle.calendarWidgetStyle.weekDayStart ?? DateTime.monday;

    _weekDayStart = weekDayStart;
    _weekdays = getWeekdaysShort(weekDayStart);

    _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);
  }

  /// Build content from widgets
  @override
  Widget buildContent(BuildContext context) {
    final commonTheme = context.commonThemeOrNull;

    final defaults = const CalendarWidgetStyle();

    final backgroundDecoration =
        widget.style?.backgroundDecoration ?? commonTheme?.formStyle.calendarWidgetStyle.backgroundDecoration ?? defaults.backgroundDecoration;

    final arrowsStyle = widget.style?.arrowsStyle ?? commonTheme?.formStyle.calendarWidgetStyle.arrowsStyle ?? defaults.arrowsStyle;
    final weekdayTextStyle = widget.style?.weekdayTextStyle ?? commonTheme?.formStyle.calendarWidgetStyle.weekdayTextStyle ?? defaults.weekdayTextStyle;
    final currentMonthStyle = widget.style?.currentMonthStyle ?? commonTheme?.formStyle.calendarWidgetStyle.currentMonthStyle ?? defaults.currentMonthStyle;
    final currentYearStyle = widget.style?.currentYearStyle ?? commonTheme?.formStyle.calendarWidgetStyle.currentYearStyle ?? defaults.currentYearStyle;

    final dayTextStyle = widget.style?.dayTextStyle ?? commonTheme?.formStyle.calendarWidgetStyle.dayTextStyle ?? defaults.dayTextStyle;
    final checkboxColor = widget.style?.checkboxColor ?? commonTheme?.formStyle.calendarWidgetStyle.checkboxColor ?? defaults.checkboxColor;
    final disabledDaysColor = widget.style?.disabledDaysColor ?? commonTheme?.formStyle.calendarWidgetStyle.disabledDaysColor ?? defaults.disabledDaysColor;
    final selectedDayColor = widget.style?.selectedDayColor ?? commonTheme?.formStyle.calendarWidgetStyle.selectedDayColor ?? defaults.selectedDayColor;
    final selectedDayTextColor =
        widget.style?.selectedDayTextColor ?? commonTheme?.formStyle.calendarWidgetStyle.selectedDayTextColor ?? defaults.selectedDayTextColor;
    final todayDayColor = widget.style?.todayDayColor ?? commonTheme?.formStyle.calendarWidgetStyle.todayDayColor ?? defaults.todayDayColor;

    final arrowLeftIcon = widget.style?.arrowLeftIcon ?? commonTheme?.formStyle.calendarWidgetStyle.arrowLeftIcon ?? defaults.arrowLeftIcon;
    final arrowRightIcon = widget.style?.arrowRightIcon ?? commonTheme?.formStyle.calendarWidgetStyle.arrowRightIcon ?? defaults.arrowRightIcon;
    final checkIcon = widget.style?.checkIcon ?? commonTheme?.formStyle.calendarWidgetStyle.checkIcon ?? defaults.checkIcon;

    addPostFrameCallback((timeStamp) {
      final theContext = _gridKey.currentContext;

      if (theContext != null) {
        final renderBox = theContext.findRenderObject() as RenderBox;

        final boundary = Boundary(renderBox.size.width, renderBox.size.height, 0, 0);

        if (boundary.width != _gridBoundary?.width) {
          _gridBoundary = boundary;

          setStateNotDisposed(() {});
        }
      }
    });

    return Container(
      decoration: backgroundDecoration,
      padding: widget.padding,
      margin: widget.margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButtonWidget(
                style: arrowsStyle,
                iconWidget: SvgPicture.asset(
                  arrowLeftIcon ?? 'images/chevron-left.svg',
                  package: arrowLeftIcon != null ? null : 'tch_common_widgets',
                  width: arrowsStyle.iconWidth,
                  height: arrowsStyle.iconHeight,
                  color: arrowsStyle.iconColor,
                ),
                onTap: () => _changeMonth(prev: true),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _displayedMonth.format(pattern: 'MMMM'),
                    style: currentMonthStyle,
                  ),
                  Text(
                    _displayedMonth.year.toString(),
                    style: currentYearStyle,
                  ),
                ],
              ),
              const Spacer(),
              IconButtonWidget(
                style: arrowsStyle,
                iconWidget: SvgPicture.asset(
                  arrowRightIcon ?? 'images/chevron-right.svg',
                  package: arrowRightIcon != null ? null : 'tch_common_widgets',
                  width: arrowsStyle.iconWidth,
                  height: arrowsStyle.iconHeight,
                  color: arrowsStyle.iconColor,
                ),
                onTap: () => _changeMonth(next: true),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _weekdays
                .map((String day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: weekdayTextStyle,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            key: _gridKey,
            height: ((_gridBoundary?.width ?? 0.0) / 7.0).ceilToDouble() * (widget.footer != null ? (_daysInMonth.length / 7.0) : 6.0),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              physics: const ClampingScrollPhysics(),
              children: _daysInMonth
                  .map((Jiffy day) => _DayWidget(
                        dayTextStyle: dayTextStyle,
                        checkboxColor: checkboxColor,
                        disabledDaysColor: disabledDaysColor,
                        selectedDayColor: selectedDayColor,
                        selectedDayTextColor: selectedDayTextColor,
                        todayDayColor: todayDayColor,
                        day: day,
                        isSelected: _isSelected(day),
                        disabledDay: _isDisabledDay(day),
                        isDifferentMonth: _isDayDifferentMonth(day),
                        onSelect: _selectDate,
                        checkbox: widget.daysWithCheckbox.any((element) => element.isSame(day, unit: Unit.day)),
                        checkIcon: checkIcon,
                      ))
                  .toList(),
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }

  /// Determine if date is selected
  bool _isSelected(Jiffy day) {
    if (widget.singleSelection) {
      return day.isSame(_selectedDate, unit: Unit.day);
    }

    if (widget.staticDate != null && day.isSame(widget.staticDate!, unit: Unit.day)) {
      return true;
    }

    return _selectedDates.any((Jiffy selectedDay) => selectedDay.isSame(day, unit: Unit.day));
  }

  /// Calculate if day is disabled based on first and last date
  bool _isDisabledDay(Jiffy day) {
    if (_firstDate != null && day.isBefore(_firstDate!)) {
      return true;
    }

    if (_lastDate != null && day.isAfter(_lastDate!)) {
      return true;
    }

    return false;
    // return !day.isSame(_displayedMonth, unit: Unit.month);
  }

  /// Calculate if day is from different month
  bool _isDayDifferentMonth(Jiffy day) {
    return !day.isSame(_displayedMonth, unit: Unit.month);
  }

  /// Select date and update days
  void _selectDate(Jiffy day) {
    if (_isDisabledDay(day) ||
        (widget.onSelect == null && widget.singleSelection) ||
        (widget.onSelectMultiple == null && !widget.singleSelection) ||
        (widget.staticDate != null && day.isSame(widget.staticDate!, unit: Unit.day))) {
      return;
    }

    widget.onTapDay?.call(day);

    if (widget.singleSelection) {
      _selectedDate = day;

      _displayedMonth = day;

      _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);

      widget.onSelect!.call(day);

      setStateNotDisposed(() {});
    } else {
      if (_selectedDates.any((Jiffy selectedDay) => selectedDay.isSame(day, unit: Unit.day))) {
        _selectedDates.removeWhere((Jiffy selectedDay) => selectedDay.isSame(day, unit: Unit.day));
        _selectedDates.sort((Jiffy a, Jiffy b) => a.millisecondsSinceEpoch.compareTo(b.millisecondsSinceEpoch));

        _displayedMonth = day;

        _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);

        setStateNotDisposed(() {
          widget.onSelectMultiple!(_selectedDates);
        });
      } else {
        _selectedDates.add(day);
        _selectedDates.sort((Jiffy a, Jiffy b) => a.millisecondsSinceEpoch.compareTo(b.millisecondsSinceEpoch));

        _displayedMonth = day;

        _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);

        widget.onSelectMultiple!(_selectedDates);

        setStateNotDisposed(() {});
      }
    }
  }

  /// Change displayed month and update days
  void _changeMonth({
    bool next = false,
    bool prev = false,
  }) {
    if (prev) {
      final prevMonth = _displayedMonth.subtract(months: 1).startOf(Unit.month);

      if (_firstDate != null && prevMonth.isBefore(_firstDate!.startOf(Unit.month))) {
        return;
      }

      setStateNotDisposed(() {
        _displayedMonth = _displayedMonth.subtract(months: 1);

        _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);
      });
    }

    if (next) {
      final nextMonth = _displayedMonth.add(months: 1).startOf(Unit.month);

      if (_lastDate != null && nextMonth.isAfter(_lastDate!.startOf(Unit.month))) {
        return;
      }

      setStateNotDisposed(() {
        _displayedMonth = _displayedMonth.add(months: 1);

        _daysInMonth = getDaysInMonth(_displayedMonth, _weekDayStart);
      });
    }
  }
}

class _DayWidget extends StatelessWidget {
  final TextStyle dayTextStyle;
  final Color checkboxColor;
  final Color disabledDaysColor;
  final Color selectedDayColor;
  final Color selectedDayTextColor;
  final Color todayDayColor;
  final Jiffy day;
  final bool isSelected;
  final bool disabledDay;
  final bool isDifferentMonth;
  final bool checkbox;
  final ValueChanged<Jiffy> onSelect;
  final String? checkIcon;

  /// DayWidget initialization
  const _DayWidget({
    required this.dayTextStyle,
    required this.checkboxColor,
    required this.disabledDaysColor,
    required this.selectedDayColor,
    required this.selectedDayTextColor,
    required this.todayDayColor,
    required this.day,
    this.isSelected = false,
    this.disabledDay = false,
    this.isDifferentMonth = false,
    this.checkbox = false,
    required this.onSelect,
    this.checkIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = day.isSame(Jiffy.now(), unit: Unit.day);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !disabledDay ? () => onSelect(day) : null,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? selectedDayColor : null,
                borderRadius: BorderRadius.circular(6),
                border: isToday && !isSelected
                    ? Border.all(
                        color: todayDayColor,
                        width: 1,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                day.dateTime.day.toString(),
                style: dayTextStyle.copyWith(
                  color: isSelected
                      ? selectedDayTextColor
                      : (disabledDay || isDifferentMonth) && !isSelected
                          ? disabledDaysColor
                          : null,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        if (checkbox)
          SvgPicture.asset(
            checkIcon ?? 'images/check.svg',
            package: checkIcon != null ? null : 'tch_common_widgets',
            width: 14,
            height: 14,
            color: checkboxColor,
          ),
      ],
    );
  }
}

class CalendarWidgetStyle {
  final int weekDayStart;
  final IconButtonStyle arrowsStyle;
  final TextStyle dayTextStyle;
  final TextStyle weekdayTextStyle;
  final TextStyle currentMonthStyle;
  final TextStyle currentYearStyle;
  final Decoration? backgroundDecoration;
  final Color checkboxColor;
  final Color disabledDaysColor;
  final Color selectedDayColor;
  final Color selectedDayTextColor;
  final Color todayDayColor;
  final String? arrowLeftIcon;
  final String? arrowRightIcon;
  final String? checkIcon;

  /// CalendarWidgetStyle initialization
  const CalendarWidgetStyle({
    this.weekDayStart = DateTime.monday,
    this.arrowsStyle = const IconButtonStyle(
      variant: IconButtonVariant.IconOnly,
    ),
    this.dayTextStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    this.weekdayTextStyle = const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
    this.currentMonthStyle = const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    this.currentYearStyle = const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    this.backgroundDecoration,
    this.checkboxColor = Colors.green,
    this.disabledDaysColor = Colors.grey,
    this.selectedDayColor = Colors.green,
    this.selectedDayTextColor = Colors.white,
    this.todayDayColor = Colors.red,
    this.arrowLeftIcon,
    this.arrowRightIcon,
    this.checkIcon,
  });

  /// Create copy if this style with changes
  CalendarWidgetStyle copyWith({
    int? weekDayStart,
    IconButtonStyle? arrowsStyle,
    TextStyle? dayTextStyle,
    TextStyle? weekdayTextStyle,
    TextStyle? currentMonthStyle,
    TextStyle? currentYearStyle,
    Decoration? backgroundDecoration,
    Color? checkboxColor,
    Color? disabledDaysColor,
    Color? selectedDayColor,
    Color? selectedDayTextColor,
    Color? todayDayColor,
    String? arrowLeftIcon,
    String? arrowRightIcon,
    String? checkIcon,
  }) {
    return CalendarWidgetStyle(
      weekDayStart: weekDayStart ?? this.weekDayStart,
      arrowsStyle: arrowsStyle ?? this.arrowsStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      weekdayTextStyle: weekdayTextStyle ?? this.weekdayTextStyle,
      currentMonthStyle: currentMonthStyle ?? this.currentMonthStyle,
      currentYearStyle: currentYearStyle ?? this.currentYearStyle,
      backgroundDecoration: backgroundDecoration ?? this.backgroundDecoration,
      checkboxColor: checkboxColor ?? this.checkboxColor,
      disabledDaysColor: disabledDaysColor ?? this.disabledDaysColor,
      selectedDayColor: selectedDayColor ?? this.selectedDayColor,
      selectedDayTextColor: selectedDayTextColor ?? this.selectedDayTextColor,
      todayDayColor: todayDayColor ?? this.todayDayColor,
      arrowLeftIcon: arrowLeftIcon ?? this.arrowLeftIcon,
      arrowRightIcon: arrowRightIcon ?? this.arrowRightIcon,
      checkIcon: checkIcon ?? this.checkIcon,
    );
  }
}
