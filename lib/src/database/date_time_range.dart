class DateTimeRange {
  final DateTime start;
  final DateTime end;

  DateTimeRange(this.start, this.end)
      : assert(start.isBefore(end) || start.isAtSameMomentAs(end));
}
