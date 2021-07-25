import 'dart:ui';

import 'package:cents/src/database/amount_range.dart';
import 'package:cents/src/database/date_time_range.dart';
import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  late ExpenseProvider provider;

  late ExpenseCategory foodCategory;
  late ExpenseCategory healthCategory;
  late List<ExpenseCategory> initialCategories;
  late List<Expense> initialExpenses;

  setUp(() async {
    sqfliteFfiInit();

    provider = await ExpenseProvider.openInMemory(
        defaultDatabaseFactory: databaseFactoryFfi);

    initialCategories = [
      ExpenseCategory(name: 'Food', color: Color.fromARGB(255, 0, 0, 255)),
      ExpenseCategory(name: 'Health', color: Color.fromARGB(255, 255, 0, 0)),
    ];
    await provider.addAllCategories(initialCategories);

    initialCategories = await provider.getEveryCategory();
    final nameCategories =
        Map.fromEntries(initialCategories.map((c) => MapEntry(c.name, c)));
    foodCategory = nameCategories['Food']!;
    healthCategory = nameCategories['Health']!;

    initialExpenses = [
      Expense(
        category: healthCategory,
        cost: Amount(10),
        createdAt: DateTime(2021, DateTime.july, 21),
        note: '',
      ),
      Expense(
        category: healthCategory,
        cost: Amount(20),
        createdAt: DateTime(2021, DateTime.july, 22),
        note: 'Some health note.',
      ),
      Expense(
        category: foodCategory,
        cost: Amount(30),
        createdAt: DateTime(2021, DateTime.july, 23),
        note: 'Some food note.',
      ),
      Expense(
        category: foodCategory,
        cost: Amount(40),
        createdAt: DateTime(2021, DateTime.july, 24),
        note: '',
      ),
      Expense(
        category: foodCategory,
        cost: Amount(50),
        createdAt: DateTime(2021, DateTime.july, 25),
        note: '',
      ),
    ];
    await provider.addAllExpenses(initialExpenses);
  });

  tearDown(() async {
    await provider.dispose();
  });

  test('Get by returns all without any criteria.', () async {
    final expenses = await provider.getExpenseBy()
      ..sort((a, b) => a.id.compareTo(b.id));

    expect(expenses, hasLength(5));
    expect(expenses[0], equalsExpenseContent(initialExpenses[0]));
    expect(expenses[1], equalsExpenseContent(initialExpenses[1]));
    expect(expenses[2], equalsExpenseContent(initialExpenses[2]));
    expect(expenses[3], equalsExpenseContent(initialExpenses[3]));
    expect(expenses[4], equalsExpenseContent(initialExpenses[4]));
  });

  test('Get by category', () async {
    final expenses = await provider.getExpenseBy(categoryName: 'Health')
      ..sort((a, b) => a.id.compareTo(b.id));

    expect(expenses, hasLength(2));
    expect(expenses[0], equalsExpenseContent(initialExpenses[0]));
    expect(expenses[1], equalsExpenseContent(initialExpenses[1]));
  });

  test('Get by costRange', () async {
    final expenses = await provider.getExpenseBy(
        costRange: AmountRange(Amount(20), Amount(40)))
      ..sort((a, b) => a.id.compareTo(b.id));

    expect(expenses, hasLength(3));
    expect(expenses[0], equalsExpenseContent(initialExpenses[1]));
    expect(expenses[1], equalsExpenseContent(initialExpenses[2]));
    expect(expenses[2], equalsExpenseContent(initialExpenses[3]));
  });

  test('Get by createdAtRange', () async {
    final expenses = await provider.getExpenseBy(
      createdAtRange: DateTimeRange(
        DateTime(2021, DateTime.july, 24),
        DateTime(2021, DateTime.july, 25),
      ),
    )
      ..sort((a, b) => a.id.compareTo(b.id));

    expect(expenses, hasLength(2));
    expect(expenses[0], equalsExpenseContent(initialExpenses[3]));
    expect(expenses[1], equalsExpenseContent(initialExpenses[4]));
  });

  test('Get by noteKeyword', () async {
    final expenses = await provider.getExpenseBy(noteKeyword: 'health');

    expect(expenses, hasLength(1));
    expect(expenses[0], equalsExpenseContent(initialExpenses[1]));
  });
}
