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
  final startOfNextMonth = _getStartOfMonth(nextMonth.year, nextMonth.month);
  return startOfNextMonth.subtract(Duration(microseconds: 1));
}

DateTime _nextMonthOf(int year, int month) {
  if (month != DateTime.december) {
    return DateTime(year, month + 1);
  } else {
    return DateTime(year + 1, DateTime.january);
  }
}
