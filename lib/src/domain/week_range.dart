import 'package:isoweek/isoweek.dart';

import 'date_time_range.dart';

const _MONDAY = 0;
const _SUNDAY = 6;

class WeekRange extends DateTimeRange {
  WeekRange get previous {
    final previousWeek = Week.fromDate(start).previous;
    return WeekRange.fromWeekOfYear(previousWeek.year, previousWeek.weekNumber);
  }

  WeekRange get next {
    final nextWeek = Week.fromDate(start).next;
    return WeekRange.fromWeekOfYear(nextWeek.year, nextWeek.weekNumber);
  }

  WeekRange._internal(DateTime start, DateTime end) : super(start, end);

  factory WeekRange.fromWeekOfYear(int year, int weekOfYear) {
    final week = Week(year: year, weekNumber: weekOfYear);

    return WeekRange._internal(week.day(_MONDAY), week.day(_SUNDAY));
  }

  factory WeekRange.fromDateTime(DateTime dateTime) {
    final week = Week.fromDate(dateTime);

    return WeekRange._internal(week.day(_MONDAY), week.day(_SUNDAY));
  }
}
