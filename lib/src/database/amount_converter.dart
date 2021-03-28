import 'package:cents/src/domain/amount.dart';
import 'package:floor/floor.dart';

class AmountConverter extends TypeConverter<Amount, int> {
  @override
  int encode(Amount amount) {
    return amount.totalCents;
  }

  @override
  Amount decode(int totalCents) {
    return Amount(0, totalCents);
  }
}
