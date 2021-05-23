const double kCommonPrimaryMargin = 16.0;
const double kCommonPrimaryMarginDouble = 32.0;
const double kCommonPrimaryMarginHalf = 8.0;

const double kCommonHorizontalMargin = 16.0;
const double kCommonHorizontalMarginDouble = 32.0;
const double kCommonHorizontalMarginHalf = 8.0;
const double kCommonHorizontalMarginQuarter = 4.0;

const double kCommonVerticalMargin = 16.0;
const double kCommonVerticalMarginDouble = 32.0;
const double kCommonVerticalMarginHalf = 8.0;
const double kCommonVerticalMarginQuarter = 4.0;

class CommonDimens {
  final double primaryMargin;
  final double primaryMarginDouble;
  final double primaryMarginHalf;
  final double horizontalMargin;
  final double horizontalMarginDouble;
  final double horizontalMarginHalf;
  final double horizontalMarginQuarter;
  final double verticalMargin;
  final double verticalMarginDouble;
  final double verticalMarginHalf;
  final double verticalMarginQuarter;

  /// CommonDimens initialization
  const CommonDimens({
    this.primaryMargin = kCommonPrimaryMargin,
    this.primaryMarginDouble = kCommonPrimaryMarginDouble,
    this.primaryMarginHalf = kCommonPrimaryMarginHalf,
    this.horizontalMargin = kCommonHorizontalMargin,
    this.horizontalMarginDouble = kCommonHorizontalMarginDouble,
    this.horizontalMarginHalf = kCommonHorizontalMarginHalf,
    this.horizontalMarginQuarter = kCommonHorizontalMarginQuarter,
    this.verticalMargin = kCommonVerticalMargin,
    this.verticalMarginDouble = kCommonVerticalMarginDouble,
    this.verticalMarginHalf = kCommonVerticalMarginHalf,
    this.verticalMarginQuarter = kCommonVerticalMarginQuarter,
  });
}
