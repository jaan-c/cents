import 'date_time_range.dart';

/// A range between a [startDay] and an [endDay].
///
/// [startDay] truncates the time parts and [endDay] is a microsecond away from
/// the next day.
class DayRange extends DateTimeRange {
  DayRange(DateTime startDay, DateTime endDay)
      : super(
          _truncateTimeParts(startDay),
          _endOfDay(endDay),
        );
}

/// Converts [dateTime]'s time parts to a microsecond away from the next day.
DateTime _endOfDay(DateTime dateTime) {
  final truncated = _truncateTimeParts(dateTime);
  final nextDay = truncated.add(Duration(days: 1));
  return nextDay.subtract(Duration(microseconds: 1));
}

DateTime _truncateTimeParts(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}
