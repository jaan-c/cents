import 'package:quiver/time.dart';

extension WeekOf on DateTime {
  int get weekOfMonth {
    final startOfMonth = DateTime(year, month, 1);

    return _dateRange(startOfMonth, this, aWeek).length + 1;
  }

  int get weekOfYear {
    final startOfYear = DateTime(year, DateTime.january, 1);

    return _dateRange(startOfYear, this, aWeek).length + 1;
  }
}

Iterable<DateTime> _dateRange(
    DateTime start, DateTime end, Duration interval) sync* {
  assert(interval != Duration.zero);
  start = DateTime(start.year, start.month, start.day);
  end = DateTime(end.year, end.month, end.day);

  var current = start;
  while (true) {
    yield current;

    if (current.isBefore(end)) {
      current = current.add(interval);
    } else {
      break;
    }
  }
}
