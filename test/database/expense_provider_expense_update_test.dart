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

  test('Expense update throws AssertionError on unset id.', () async {
    final expense = Expense(
        id: Expense.UNSET_ID,
        category: category,
        cost: Amount(10),
        createdAt: DateTime.now());

    await expectLater(
        () => provider.updateAllExpenses([expense]), throwsAssertionError);
  });

  test('Expense update throws AssertionError on unset category id.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
    ]);

    var expense = (await provider.getEveryExpense()).first;
    expense = expense.copyWith(
        category: ExpenseCategory(
            id: ExpenseCategory.UNSET_ID, name: 'New Category'));
    await expectLater(
        () => provider.updateAllExpenses([expense]), throwsAssertionError);
  });

  test('Expense update throws StateError on non-existent category.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
    ]);

    var expense = (await provider.getEveryExpense()).first;
    expense = expense.copyWith(
        category: ExpenseCategory(
            id: category.id + 1, name: 'Non-existent Category'));
    await expectLater(
        () => provider.updateAllExpenses([expense]), throwsStateError);
  });

  test('Expense update is no op on non-existent id.', () async {
    final expense = Expense(
        category: category, cost: Amount(10), createdAt: DateTime.now());
    await provider.addAllExpenses([expense]);

    var e = (await provider.getEveryExpense()).first;
    e = expense.copyWith(id: e.id + 1, cost: Amount(20), note: 'Some notes.');
    await provider.updateAllExpenses([e]);

    expect(await provider.getExpense(e.id - 1), equalsExpenseContent(expense));
  });

  test('Expense update keeps other records intact.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(20), createdAt: DateTime.now()),
    ]);

    final es = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    var e1 = es[0];
    e1 = e1.copyWith(cost: Amount(11), note: 'Some note.');
    await provider.updateAllExpenses([e1]);
    final e2 = es[1];

    expect(await provider.getExpense(e1.id), e1);
    expect(await provider.getExpense(e2.id), e2);
  });

  test('Expense update single.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
    ]);

    var updatedExpense = (await provider.getEveryExpense()).first;
    updatedExpense =
        updatedExpense.copyWith(cost: Amount(11), note: 'Some note.');
    await provider.updateAllExpenses([updatedExpense]);

    expect(await provider.getExpense(updatedExpense.id), updatedExpense);
  });

  test('Expense update multiple.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(20), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(30), createdAt: DateTime.now()),
    ]);

    final expenses = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    var e1 = expenses[0];
    var e2 = expenses[1];
    var e3 = expenses[2];
    e1 = e1.copyWith(cost: Amount(11), note: 'Note 1');
    e2 = e2.copyWith(cost: Amount(22), note: 'Note 2');
    e3 = e3.copyWith(cost: Amount(33), note: 'Note 3');
    await provider.updateAllExpenses([e1, e2, e3]);

    expect(await provider.getExpense(e1.id), e1);
    expect(await provider.getExpense(e2.id), e2);
    expect(await provider.getExpense(e3.id), e3);
  });
}
