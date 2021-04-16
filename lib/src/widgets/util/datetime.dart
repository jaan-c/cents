import 'package:intl/intl.dart';

extension RelativeDisplay on DateTime {
  String time12Display() {
    return DateFormat.jm().format(this);
  }

  String dateDisplay() {
    return DateFormat.yMMMd().format(this);
  }

  String display() {
    return '${dateDisplay()}, ${time12Display()}';
  }

  String relativeDateDisplay([DateTime? now]) {
    now ??= DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    if (equalDate(now)) {
      return 'Today';
    } else if (equalDate(yesterday)) {
      return 'Yesterday';
    } else if (weekOfYear == now.weekOfYear) {
      /// Example: Fri, Mar 12
      return '${DateFormat.E().format(this)}, ${DateFormat.MMMd().format(this)}';
    } else if (year == now.year) {
      // Example: Mar 12
      return '${DateFormat.MMMd().format(this)}';
    } else {
      return dateDisplay();
    }
  }

  String relativeDisplay([DateTime? now]) {
    now ??= DateTime.now();

    return '${relativeDateDisplay(now)}, ${time12Display()}';
  }
}

extension WeekOfYear on DateTime {
  int get weekOfYear {
    final oneDay = Duration(days: 1);

    var weekCount = 1;
    var dateTime = DateTime(year);

    while (dateTime.isBefore(this)) {
      dateTime = dateTime.add(oneDay);

      if (dateTime.weekday == DateTime.monday) {
        weekCount++;
      }
    }

    return weekCount;
  }
}

extension ExtendedEquality on DateTime {
  bool equalDate(DateTime other) {
    return timeZoneOffset == other.timeZoneOffset &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }
}
