import 'comparable_operators.dart';

/// A monetary amount not tied to any currency.
class Amount with ComparableOperators<Amount> implements Comparable<Amount> {
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
    if (cents != 0) {
      return '$units.${cents.toString().padLeft(2, '0')}';
    } else {
      return '$units';
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
