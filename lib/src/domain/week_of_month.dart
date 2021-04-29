class WeekOfMonth {
  static const values = [first, second, third, fourth, fifth];

  static const first = WeekOfMonth.fromInt(1);
  static const second = WeekOfMonth.fromInt(2);
  static const third = WeekOfMonth.fromInt(3);
  static const fourth = WeekOfMonth.fromInt(4);
  static const fifth = WeekOfMonth.fromInt(5);

  final int asInt;

  String get asOrdinal {
    switch (asInt) {
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
      default:
        throw StateError('Invalid week of month $asInt');
    }
  }

  const WeekOfMonth.fromInt(int weekOfMonth)
      : assert(1 <= weekOfMonth && weekOfMonth <= 5),
        asInt = weekOfMonth;

  @override
  bool operator ==(dynamic other) {
    return other is WeekOfMonth && asInt == other.asInt;
  }

  @override
  int get hashCode => asInt.hashCode;
}
