import 'package:cents/src/domain/amount.dart';

class AmountRange {
  final Amount start;
  final Amount end;

  AmountRange(this.start, this.end) : assert(start <= end);
}
