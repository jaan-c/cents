import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'week_of_month.dart';

extension ExtDate on DateTime {
  WeekOfMonth get weekOfMonth {
    final startOfMonth = DateTime(year, month, 1);

    return WeekOfMonth.fromInt(_dateRange(startOfMonth, this, aWeek).length);
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

  String time12Display() {
    return DateFormat.jm().format(this);
  }

  String dateDisplay() {
    return DateFormat.yMMMd().format(this);
  }

  String display() {
    return '${dateDisplay()}, ${time12Display()}';
  }

  String relativeDisplay([DateTime? now]) {
    now ??= DateTime.now();

    if (!now.difference(this).isNegative) {
      return timeago.format(this, clock: now);
    } else {
      return display();
    }
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
