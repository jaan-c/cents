import 'package:isoweek/isoweek.dart';

class DateTimeRange {
  final DateTime start;
  final DateTime end;

  DateTimeRange(this.start, this.end);

  bool isInRange(DateTime dateTime) {
    return (start.isBefore(dateTime) || start.isAtSameMomentAs(dateTime)) &&
        (dateTime.isBefore(end) || dateTime.isAtSameMomentAs(end));
  }

  @override
  String toString() {
    return 'DateTimeRange($start, $end)';
  }
}

class MonthRange extends DateTimeRange {
  MonthRange get previous {
    if (start.month == DateTime.january) {
      return MonthRange(start.year - 1, DateTime.december);
    } else {
      return MonthRange(start.year, start.month - 1);
    }
  }

  MonthRange get next {
    if (start.month == DateTime.december) {
      return MonthRange(start.year + 1, DateTime.january);
    } else {
      return MonthRange(start.year, start.month + 1);
    }
  }

  MonthRange(int year, int month)
      : assert(DateTime.january <= month && month <= DateTime.december),
        super(_getStartOfMonth(year, month), _getEndOfMonth(year, month));
}

DateTime _getStartOfMonth(int year, int month) {
  return DateTime(year, month);
}

DateTime _getEndOfMonth(int year, int month) {
  final startOfMonth = _getStartOfMonth(year, month);
  final startOfNextMonth = startOfMonth.month != DateTime.december
      ? _getStartOfMonth(startOfMonth.year, startOfMonth.month + 1)
      : _getStartOfMonth(startOfMonth.year + 1, DateTime.january);

  return startOfNextMonth.subtract(Duration(days: 1));
}

class WeekRange extends DateTimeRange {
  WeekRange get previous {
    final previousWeek = Week.fromDate(start).previous;
    return WeekRange.ofYear(previousWeek.year, previousWeek.weekNumber);
  }

  WeekRange get next {
    final nextWeek = Week.fromDate(start).next;
    return WeekRange.ofYear(nextWeek.year, nextWeek.weekNumber);
  }

  WeekRange.ofYear(int year, int weekOfYear)
      : super(_getStartOfWeekOfYear(year, weekOfYear),
            _getEndOfWeekOfYear(year, weekOfYear));
}

DateTime _getStartOfWeekOfYear(int year, int weekOfYear) {
  final week = Week(year: year, weekNumber: weekOfYear);
  return week.day(0); // Monday
}

DateTime _getEndOfWeekOfYear(int year, int weekOfYear) {
  final week = Week(year: year, weekNumber: weekOfYear);
  return week.day(6); // Sunday
}
