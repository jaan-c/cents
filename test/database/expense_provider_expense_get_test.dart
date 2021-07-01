import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('Expense get throws AssertionError on unset id.', () async {
    await expectLater(
        () => provider.getExpense(Expense.UNSET_ID), throwsAssertionError);
    await expectLater(() => provider.getAllExpenses([Expense.UNSET_ID]),
        throwsAssertionError);
  });

  test('Expense get returns null on non-existent id.', () async {
    await provider.addAllExpenses([
      Expense(
          category: category,
          cost: Amount(10),
          createdAt: DateTime.now(),
          note: 'Expense 1'),
      Expense(
          category: category,
          cost: Amount(20),
          createdAt: DateTime.now(),
          note: 'Expense 2'),
      Expense(
          category: category,
          cost: Amount(30),
          createdAt: DateTime.now(),
          note: 'Expense 3'),
    ]);

    final es = (await provider.getEveryExpense());
    final nonExistentId = es.fold<int>(0, (acc, e) => acc + e.id);

    expect(await provider.getExpense(nonExistentId), isNull);
  });

  test('Expense get single.', () async {
    await provider.addAllExpenses([
      Expense(
          category: category,
          cost: Amount(10),
          createdAt: DateTime.now(),
          note: 'Expense 1'),
      Expense(
          category: category,
          cost: Amount(20),
          createdAt: DateTime.now(),
          note: 'Expense 2'),
      Expense(
          category: category,
          cost: Amount(30),
          createdAt: DateTime.now(),
          note: 'Expense 3'),
    ]);

    final es = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    final e1 = es[0];

    expect(await provider.getExpense(e1.id), e1);
  });

  test('Expense get multiple.', () async {
    await provider.addAllExpenses([
      Expense(
          category: category,
          cost: Amount(10),
          createdAt: DateTime.now(),
          note: 'Expense 1'),
      Expense(
          category: category,
          cost: Amount(20),
          createdAt: DateTime.now(),
          note: 'Expense 2'),
      Expense(
          category: category,
          cost: Amount(30),
          createdAt: DateTime.now(),
          note: 'Expense 3'),
    ]);

    final es = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    final e1 = es[0];
    final e2 = es[1];

    expect(await provider.getAllExpenses([e1.id, e2.id]), equals([e1, e2]));
  });

  test('Expense get everything.', () async {
    await provider.addAllExpenses([
      Expense(
          category: category,
          cost: Amount(10),
          createdAt: DateTime.now(),
          note: 'Expense 1'),
      Expense(
          category: category,
          cost: Amount(20),
          createdAt: DateTime.now(),
          note: 'Expense 2'),
      Expense(
          category: category,
          cost: Amount(30),
          createdAt: DateTime.now(),
          note: 'Expense 3'),
    ]);

    final es = (await provider.getEveryExpense())
      ..sort((a, b) => a.id.compareTo(b.id));
    final e1 = es[0];
    final e2 = es[1];
    final e3 = es[2];

    expect(
        (await provider.getEveryExpense())
          ..sort((a, b) => a.id.compareTo(b.id)),
        equals([e1, e2, e3]));
  });
}
