extension ExtDouble on double {
  double ceilingByPlaceValue({int minPlaceValue = 2, int maxPlaceValue = 3}) {
    assert(this >= 0);
    assert(minPlaceValue >= 0);
    assert(maxPlaceValue >= 0);
    assert(minPlaceValue <= maxPlaceValue);

    final placeValue = _clip(_placeValueOf(this), minPlaceValue, maxPlaceValue);
    final placeValueFloor = int.parse('1'.padRight(placeValue, '0'));

    final ceiled = (this / placeValueFloor).ceilToDouble() * placeValueFloor;
    if (ceiled != this) {
      return ceiled;
    } else {
      return ceiled + placeValueFloor;
    }
  }
}

int _placeValueOf(double n) {
  if (n == 0) {
    return 0;
  } else {
    return n.toInt().toString().length;
  }
}

int _clip(int n, int min, int max) {
  if (n < min) {
    return min;
  } else if (n > max) {
    return max;
  } else {
    return n;
  }
}
