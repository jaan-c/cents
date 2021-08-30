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

class DateRange extends DateTimeRange {
  DateRange(DateTime startDay, DateTime endDay)
      : super(
          DateTime(startDay.year, startDay.month, startDay.day),
          DateTime(endDay.year, endDay.month, endDay.day, 23, 59, 59, 999),
        );
}

class MonthRange extends DateTimeRange {
  final int year;
  final int month;

  MonthRange get previous {
    if (month != DateTime.january) {
      return MonthRange(year, month - 1);
    } else {
      return MonthRange(year - 1, DateTime.december);
    }
  }

  MonthRange get next {
    final nextMonth = _nextMonthOf(year, month);
    return MonthRange(nextMonth.year, nextMonth.month);
  }

  MonthRange(int year, int month)
      : assert(DateTime.january <= month && month <= DateTime.december),
        year = year,
        month = month,
        super(_getStartOfMonth(year, month), _getEndOfMonth(year, month));
}

DateTime _getStartOfMonth(int year, int month) {
  final fourthDay = DateTime(year, month, 4);
  final firstWeek = Week.fromDate(fourthDay);
  return firstWeek.days.first;
}

DateTime _getEndOfMonth(int year, int month) {
  final nextMonth = _nextMonthOf(year, month);
  final fourthDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month, 4);
  final firstWeekOfNextMonth = Week.fromDate(fourthDayOfNextMonth);

  return firstWeekOfNextMonth.previous.days.last;
}

DateTime _nextMonthOf(int year, int month) {
  if (month != DateTime.december) {
    return DateTime(year, month + 1);
  } else {
    return DateTime(year + 1, DateTime.january);
  }
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
