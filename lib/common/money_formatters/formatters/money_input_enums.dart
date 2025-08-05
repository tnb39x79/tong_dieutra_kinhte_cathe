/*
Source https://github.com/deval18/multi_formatter
*/

enum ShorteningPolicy {
  /// displays a value of 1234456789.34 as 1,234,456,789.34
  noShortening, 
  /// displays a value of 1234456789.34 as 1,234,456K
  roundToThousands,

  /// displays a value of 1234456789.34 as 1,234M
  roundToMillions,

  /// displays a value of 1234456789.34 as 1B
  roundToBillions,
  roundToTrillions,

  /// uses K, M, B, or T depending on how big the numeric value is
  automatic
}

/// [Comma] means this format 1,000,000.00
/// [Period] means thousands and mantissa will look like this
/// 1.000.000,00
/// [None] no separator will be applied at all
/// [SpaceAndPeriodMantissa] 1 000 000.00
/// [SpaceAndCommaMantissa] 1 000 000,00
enum ThousandSeparator {
  comma,
  period,
  none,
  space,
  spaceAndPeriodMantissa,
  spaceAndCommaMantissa,
}
