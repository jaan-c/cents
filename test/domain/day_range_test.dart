import 'package:cents/src/domain/day_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dayRange = DayRange(
    DateTime(2021, DateTime.september, 27, 12, 43),
    DateTime(2021, DateTime.october, 3, 20, 22),
  );

  test("startDay's time is truncated.", () {
    expect(dayRange.start, DateTime(2021, DateTime.september, 27));
  });

  test('endDay is a microsecond away from next day.', () {
    final nextDay = DateTime(2021, DateTime.october, 4);
    expect(dayRange.end, nextDay.subtract(Duration(microseconds: 1)));
  });
}
