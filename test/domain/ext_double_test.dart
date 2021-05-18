import 'package:flutter_test/flutter_test.dart';
import 'package:cents/src/domain/ext_double.dart';

void main() {
  test('ceilingByPlaceValue', () {
    expect(0.0.ceilingByPlaceValue(), 10.0);
    expect(1.0.ceilingByPlaceValue(), 10.0);
    expect(100.0.ceilingByPlaceValue(), 200.0);
    expect(1000.0.ceilingByPlaceValue(), 1100.0);
    expect(2134.0.ceilingByPlaceValue(), 2200.0);
  });
}
