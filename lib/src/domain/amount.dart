/// A monetary amount not tied to any currency.
class Amount {
  static const _CENTS_PER_UNIT = 100;

  final int totalCents;

  int get units => (totalCents / _CENTS_PER_UNIT).truncate();
  int get cents => totalCents - (units * _CENTS_PER_UNIT);

  const Amount._internal(this.totalCents);

<<<<<<< HEAD
  const Amount({int unit = 0, int cents = 0})
=======
  const Amount([int unit = 0, int cents = 0])
>>>>>>> create-expense-list-page
      : this._internal(cents + (unit * _CENTS_PER_UNIT));

  Amount add(Amount other) {
    return Amount._internal(totalCents + other.totalCents);
  }

  Amount subtract(Amount other) {
    return Amount._internal(totalCents - other.totalCents);
  }

  bool operator ==(dynamic other) {
    return other is Amount && hashCode == other.hashCode;
  }

  @override
  int get hashCode => totalCents.hashCode;
}
