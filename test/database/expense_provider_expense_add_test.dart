import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  late ExpenseProvider provider;
  late ExpenseCategory category;

  setUp(() async {
    sqfliteFfiInit();

    provider = await ExpenseProvider.openInMemory(
        defaultDatabaseFactory: databaseFactoryFfi);

    category = ExpenseCategory(name: 'Category');
    await provider.addAllCategories([category]);
    category = (await provider.getEveryCategory()).first;
  });

  tearDown(() async {
    await provider.dispose();
  });

  test('Expense add throws AssertionError on set id.', () async {
    final expense = Expense(
        id: 1, category: category, cost: Amount(10), createdAt: DateTime.now());

    await expectLater(
        () => provider.addAllExpenses([expense]), throwsAssertionError);
  });

  test('Expense add throws AssertionError on unset category id.', () async {
    final expense = Expense(
        id: Expense.UNSET_ID,
        category:
            ExpenseCategory(id: ExpenseCategory.UNSET_ID, name: 'New Category'),
        cost: Amount(10),
        createdAt: DateTime.now());

    await expectLater(
        () => provider.addAllExpenses([expense]), throwsAssertionError);
  });

  test('Expense add throws StateError on non-existent category.', () async {
    final expense = Expense(
        id: Expense.UNSET_ID,
        category: category.copyWith(id: category.id + 1),
        cost: Amount(10),
        createdAt: DateTime.now());

    await expectLater(
        () => provider.addAllExpenses([expense]), throwsStateError);
  });

  test('Expense add single.', () async {
    final expense = Expense(
        category: category, cost: Amount(10), createdAt: DateTime.now());

    await provider.addAllExpenses([expense]);

    final es = await provider.getEveryExpense();
    final e = es.first;
    expect(e, equalsExpenseContent(expense));
    expect(es, hasLength(1));
  });

  test('Expense add multiple.', () async {
    final expense1 = Expense(
        category: category, cost: Amount(10), createdAt: DateTime.now());
    final expense2 = Expense(
        category: category, cost: Amount(10), createdAt: DateTime.now());
    final expense3 = Expense(
        category: category, cost: Amount(10), createdAt: DateTime.now());

    await provider.addAllExpenses([expense1, expense2, expense3]);

    final es = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    expect(es[0], equalsExpenseContent(expense1));
    expect(es[1], equalsExpenseContent(expense2));
    expect(es[2], equalsExpenseContent(expense3));
    expect(es, hasLength(3));
  });
}
