import 'package:quiver/time.dart';

extension DateExt on DateTime {
  int get weekOfMonth {
    final startOfMonth = DateTime(year, month, 1);

    return _dateRange(startOfMonth, this, aWeek).length;
  }

  int get weekOfYear {
    final startOfYear = DateTime(year, DateTime.january, 1);

    return _dateRange(startOfYear, this, aWeek).length;
  }

  int get lastDayOfMonth {
    late final DateTime nextMonth;
    if (month == 12) {
      nextMonth = DateTime(year + 1, DateTime.january);
    } else {
      nextMonth = DateTime(year, month + 1);
    }

    return nextMonth.subtract(aDay).day;
  }
}

Iterable<DateTime> _dateRange(
    DateTime start, DateTime end, Duration interval) sync* {
  assert(interval != Duration.zero);
  start = DateTime(start.year, start.month, start.day);
  end = DateTime(end.year, end.month, end.day);

  var current = start;
  while (current == end || current.isBefore(end)) {
    yield current;

    current = current.add(interval);
  }
}
