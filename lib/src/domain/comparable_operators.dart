mixin ComparableOperators<T> {
  int compareTo(T other);

  @override
  bool operator ==(dynamic other) {
    return other is T && compareTo(other) == 0;
  }

  bool operator <(T other) {
    return compareTo(other) < 0;
  }

  bool operator >(T other) {
    return compareTo(other) > 0;
  }

  bool operator <=(T other) {
    return compareTo(other) <= 0;
  }

  bool operator >=(T other) {
    return compareTo(other) >= 0;
  }
}
