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

  factory Amount.fromDouble(double n) {
    final units = n.floor();
    final cents = ((n - units) * _CENTS_PER_UNIT).toInt();

    return Amount(units, cents);
  }

  factory Amount.parse(String text) {
    final parsed = double.parse(text);

    return Amount.fromDouble(parsed);
  }

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

  double toDouble() {
    return units + (cents / _CENTS_PER_UNIT);
  }

  @override
  String toString() {
    if (cents == 0) {
      return units.toString();
    } else {
      return NumberFormat('#.00').format(toDouble());
    }
  }

  String toLocalString({
    String currencySymbol = _PESOS,
    bool compact = false,
  }) {
    if (compact) {
      return NumberFormat.compactCurrency(
              symbol: currencySymbol, decimalDigits: 1)
          .format(toDouble());
    } else {
      return NumberFormat.currency(
              symbol: currencySymbol, decimalDigits: cents == 0 ? 0 : 2)
          .format(toDouble());
    }
  }
}
