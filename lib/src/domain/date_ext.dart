import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

import 'week_of_month.dart';

extension DateExt on DateTime {
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

  String relativeDateDisplay([DateTime? now]) {
    now ??= DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    if (_onTheSameDay(this, now)) {
      return 'Today';
    } else if (_onTheSameDay(this, yesterday)) {
      return 'Yesterday';
    } else if (weekOfYear == now.weekOfYear) {
      // Fri, Mar 12
      return DateFormat('E, MMM d').format(this);
    } else if (year == now.year) {
      // Mar 12
      return DateFormat.MMMd().format(this);
    } else {
      return dateDisplay();
    }
  }

  String display() {
    return '${dateDisplay()}, ${time12Display()}';
  }

  String relativeDisplay([DateTime? now]) {
    now ??= DateTime.now();

    return '${relativeDateDisplay(now)}, ${time12Display()}';
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

bool _onTheSameDay(DateTime a, DateTime b) {
  return a.timeZoneOffset == b.timeZoneOffset &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}
