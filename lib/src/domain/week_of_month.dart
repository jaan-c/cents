import 'package:quiver/time.dart';

class WeekOfMonth {
  static const values = [first, second, third, fourth, fifth, sixth];

  static const first = WeekOfMonth.fromInt(1);
  static const second = WeekOfMonth.fromInt(2);
  static const third = WeekOfMonth.fromInt(3);
  static const fourth = WeekOfMonth.fromInt(4);
  static const fifth = WeekOfMonth.fromInt(5);
  static const sixth = WeekOfMonth.fromInt(6);

  final int _asInt;

  const WeekOfMonth.fromInt(int weekOfMonth)
      : assert(1 <= weekOfMonth && weekOfMonth <= 6),
        _asInt = weekOfMonth;

  factory WeekOfMonth.fromDateTime(DateTime dateTime) {
    final startOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    final offset = startOfMonth.weekday != DateTime.monday ? 1 : 0;
    final mondaysSinceStartOfMonth = _dateRange(startOfMonth, dateTime, aDay)
        .where((d) => d.weekday == DateTime.monday);

    return WeekOfMonth.fromInt(mondaysSinceStartOfMonth.length + offset);
  }

  @override
  bool operator ==(dynamic other) {
    return other is WeekOfMonth && hashCode == other.hashCode;
  }

  @override
  int get hashCode => _asInt.hashCode;

  int toInt() {
    return _asInt;
  }

  @override
  String toString() {
    return '${toOrdinalString()} Week';
  }

  String toOrdinalString() {
    switch (toInt()) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      case 4:
        return '4th';
      case 5:
        return '5th';
      case 6:
        return '6th';
      default:
        throw StateError('Invalid week of month ${toInt()}');
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
