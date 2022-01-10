import 'package:flutter_test/flutter_test.dart';
import 'package:cents/src/domain/week_range.dart';

void main() {
  test('Start of 4th week of 2022 is Jan 24.', () {
    final fourthWeek = WeekRange.fromWeekOfYear(2022, 4);

    expect(fourthWeek.start, DateTime(2022, DateTime.january, 24));
  });

  test('End of 4th week of 2022 is Jan 30', () {
    final fourthWeek = WeekRange.fromWeekOfYear(2022, 4);

    expect(fourthWeek.end, DateTime(2022, DateTime.january, 30));
  });

  test('Start of Feb 13 week is Feb 10', () {
    final feb13 = WeekRange.fromDateTime(DateTime(2022, DateTime.february, 13));

    expect(feb13.start, DateTime(2022, DateTime.february, 10));
  });

  test('End of Feb 28 week is Feb 16', () {
    final feb13 = WeekRange.fromDateTime(DateTime(2022, DateTime.february, 13));

    expect(feb13.end, DateTime(2022, DateTime.february, 16));
  });
}
