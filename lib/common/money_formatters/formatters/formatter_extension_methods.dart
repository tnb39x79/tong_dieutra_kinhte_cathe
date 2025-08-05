/*
Source https://github.com/deval18/multi_formatter
*/

import 'currency_input_formatter.dart';
import 'formatter_utils.dart' as fu;
import 'money_input_enums.dart';

/// WARNING! This stuff requires Dart SDK version 2.6+
/// so if your code is supposed to be running on
/// older versions do not use these methods!
/// or change the sdk restrictions in your pubspec.yaml like this:
/// environment:
///   sdk: ">=2.6.0 <3.0.0"

extension NumericInputFormatting on num {
  /// [thousandSeparator] specifies what symbol will be used to separate
  /// each block of 3 digits, e.g. [ThousandSeparator.Comma] will format
  /// a million as 1,000,000
  /// [shorteningPolicy] is used to round values using K for thousands, M for
  /// millions and B for billions
  /// [ShorteningPolicy.NoShortening] displays a value of 1234456789.34 as 1,234,456,789.34
  /// but [ShorteningPolicy.RoundToThousands] displays the same value as 1,234,456K
  /// [mantissaLength] specifies how many digits will be added after a period sign
  /// [leadingSymbol] any symbol (except for the ones that contain digits) the will be
  /// added in front of the resulting string. E.g. $ or €
  /// some of the signs are available via constants like [CurrencySymbols.EURO_SIGN]
  /// but you can basically add any string instead of it. The main rule is that the string
  /// must not contain digits, periods, commas and dashes
  /// [trailingSymbol] is the same as leading but this symbol will be added at the
  /// end of your resulting string like 1,250€ instead of €1,250
  /// [useSymbolPadding] adds a space between the number and trailing / leading symbols
  /// like 1,250€ -> 1,250 € or €1,250€ -> € 1,250
  String toCurrencyString({
    int mantissaLength = 2,
    ThousandSeparator thousandSeparator = ThousandSeparator.comma,
    ShorteningPolicy shorteningPolicy = ShorteningPolicy.noShortening,
    String leadingSymbol = '',
    String trailingSymbol = '',
    bool useSymbolPadding = false,
  }) {
    return fu.toCurrencyString(
      this.toString(),
      mantissaLength: mantissaLength,
      leadingSymbol: leadingSymbol,
      shorteningPolicy: shorteningPolicy,
      thousandSeparator: thousandSeparator,
      trailingSymbol: trailingSymbol,
      useSymbolPadding: useSymbolPadding,
    );
  }
}

extension StringInputFormatting on String {
  // bool get isFiatCurrency {
  //   return fu.isFiatCurrency(this);
  // }

  // bool get isCryptoCurrency {
  //   return fu.isCryptoCurrency(this);
  // }

  String reverse() {
    return split('').reversed.join();
  }

  String removeLast() {
    if (isEmpty) return this;
    return substring(0, length - 1);
  }

  /// [thousandSeparator] specifies what symbol will be used to separate
  /// each block of 3 digits, e.g. [ThousandSeparator.Comma] will format
  /// a million as 1,000,000
  /// [shorteningPolicy] is used to round values using K for thousands, M for
  /// millions and B for billions
  /// [ShorteningPolicy.NoShortening] displays a value of 1234456789.34 as 1,234,456,789.34
  /// but [ShorteningPolicy.RoundToThousands] displays the same value as 1,234,456K
  /// [mantissaLength] specifies how many digits will be added after a period sign
  /// [leadingSymbol] any symbol (except for the ones that contain digits) the will be
  /// added in front of the resulting string. E.g. $ or €
  /// some of the signs are available via constants like [MoneyInputFormatter.EURO_SIGN]
  /// but you can basically add any string instead of it. The main rule is that the string
  /// must not contain digits, periods, commas and dashes
  /// [trailingSymbol] is the same as leading but this symbol will be added at the
  /// end of your resulting string like 1,250€ instead of €1,250
  /// [useSymbolPadding] adds a space between the number and trailing / leading symbols
  /// like 1,250€ -> 1,250 € or €1,250€ -> € 1,250
  String toCurrencyString({
    int mantissaLength = 2,
    ThousandSeparator thousandSeparator = ThousandSeparator.comma,
    ShorteningPolicy shorteningPolicy = ShorteningPolicy.noShortening,
    String leadingSymbol = '',
    String trailingSymbol = '',
    bool useSymbolPadding = false,
  }) {
    return fu.toCurrencyString(
      toString(),
      mantissaLength: mantissaLength,
      leadingSymbol: leadingSymbol,
      shorteningPolicy: shorteningPolicy,
      thousandSeparator: thousandSeparator,
      trailingSymbol: trailingSymbol,
      useSymbolPadding: useSymbolPadding,
    );
  }
}