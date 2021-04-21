import 'package:quiver/core.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(DateTime start, DateTime end)
      : assert(start.isBefore(end)),
        start = DateTime(start.year, start.month, start.day),
        end = DateTime(end.year, end.month, end.day);

  factory DateRange.ofMonth(DateTime monthSource) {
    final start = DateTime(monthSource.year, monthSource.month, 1);
    late final DateTime end;
    if (monthSource.month == 12) {
      end = DateTime(monthSource.year + 1).subtract(Duration(days: 1));
    } else {
      end = DateTime(monthSource.year, monthSource.month + 1, 1)
          .subtract(Duration(days: 1));
    }

    return DateRange(start, end);
  }

  bool inRange(DateTime dateTime) {
    final clipped = DateTime(dateTime.year, dateTime.month, dateTime.day);

    return (start.isBefore(clipped) || start.isAtSameMomentAs(clipped)) &&
        (clipped.isBefore(end) || clipped.isAtSameMomentAs(end));
  }

  @override
  bool operator ==(dynamic other) {
    return other is DateRange && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hash2(start, end);
}
