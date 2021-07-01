import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cents/src/domain/ext_date_time.dart';

void main() {
  test('lastDayOfMonth must be 30 for April 2021', () {
    final april = DateTime(2021, DateTime.april);

    expect(april.lastDayOfMonth, 30);
  });

  test('weekOfMonth must be 1 for April 1, 2021', () {
    final april = DateTime(2021, DateTime.april, 1);

    expect(april.weekOfMonth, WeekOfMonth.first);
  });

  test('weekOfMonth must be 5 for April 30, 2021', () {
    final april = DateTime(2021, DateTime.april, 30);

    expect(april.weekOfMonth, WeekOfMonth.fifth);
  });

  test('weekOfMonth must be 6th for May 31, 2021', () {
    final may = DateTime(2021, DateTime.may, 31);

    expect(may.weekOfMonth, WeekOfMonth.sixth);
  });
}
