import 'package:intl/intl.dart';

import 'comparable_operators.dart';

/// A monetary amount not tied to any currency.
class Amount with ComparableOperators<Amount> implements Comparable<Amount> {
  static const _PESOS = '₱';
  static const _CENTS_PER_UNIT = 100;

  final int totalCents;

  int get units => (totalCents / _CENTS_PER_UNIT).truncate();
  int get cents => totalCents - (units * _CENTS_PER_UNIT);

  Amount.fromTotalCents(this.totalCents);

  Amount([int unit = 0, int cents = 0])
      : assert(0 <= cents && cents <= 99),
        totalCents = cents + (unit * _CENTS_PER_UNIT);

  Amount.parse(String text) : this.fromTotalCents(_textToTotalCents(text));

  Amount add(Amount other) {
    return Amount.fromTotalCents(totalCents + other.totalCents);
  }

  Amount subtract(Amount other) {
    return Amount.fromTotalCents(totalCents - other.totalCents);
  }

  @override
  int compareTo(Amount other) {
    return totalCents.compareTo(other.totalCents);
  }

  @override
  String toString() {
    final asDecimal = double.parse('$units.$cents');

    if (cents == 0) {
      return units.toString();
    } else {
      return NumberFormat('#.00').format(asDecimal);
    }
  }

  String toLocalString({
    String currencySymbol = _PESOS,
    bool compact = false,
  }) {
    final asDecimal = double.parse('$units.$cents');

    if (compact) {
      return NumberFormat.compactCurrency(
              symbol: currencySymbol, decimalDigits: 1)
          .format(asDecimal);
    } else {
      return NumberFormat.currency(
              symbol: currencySymbol, decimalDigits: cents == 0 ? 0 : 2)
          .format(asDecimal);
    }
  }
}

int _textToTotalCents(String text) {
  text = double.parse(text).toString();

  final split = text.split('.');
  final unit = int.parse(split[0]);
  final cents = split.length == 2 ? int.parse(split[1]) : 0;

  return Amount(unit, cents).totalCents;
}
