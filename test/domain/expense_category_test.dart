import 'dart:ui';

import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('==', () {
    final category1 = ExpenseCategory(
        id: 1, name: 'Category', color: Color.fromARGB(255, 128, 128, 128));
    final category2 = ExpenseCategory(
        id: 1, name: 'Category', color: Color.fromARGB(255, 128, 128, 128));

    expect(category1, category2);
  });
}
