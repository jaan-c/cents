import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, String> {
  @override
  String encode(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  @override
  DateTime decode(String timestamp) {
    return DateTime.parse(timestamp);
  }
}
