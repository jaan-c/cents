import 'dart:ui';

import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('==', () {
    final expense1 = Expense(
        id: 1,
        category: ExpenseCategory(
            id: 1, name: 'Category', color: Color.fromARGB(255, 128, 128, 128)),
        cost: Amount(1),
        createdAt: DateTime(2021, DateTime.january, 1));
    final expense2 = Expense(
        id: 1,
        category: ExpenseCategory(
            id: 1, name: 'Category', color: Color.fromARGB(255, 128, 128, 128)),
        cost: Amount(1),
        createdAt: DateTime(2021, DateTime.january, 1));

    expect(expense1, expense2);
  });
}
