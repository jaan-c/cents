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

  test('Expense delete throws AssertionError on unset id.', () async {
    await expectLater(() => provider.deleteAllExpenses([Expense.UNSET_ID]),
        throwsAssertionError);
  });

  test('Expense delete is no op on non-existent id.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now())
    ]);

    final es = await provider.getEveryExpense();
    final nonExistentId = es.fold<int>(0, (acc, e) => acc + e.id);
    await provider.deleteAllExpenses([nonExistentId]);

    expect(await provider.getEveryExpense(), hasLength(3));
  });

  test('Expense delete single.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now())
    ]);

    final e = (await provider.getEveryExpense()).first;
    await provider.deleteAllExpenses([e.id]);

    expect(await provider.getEveryExpense(), hasLength(2));
  });

  test('Expense delete multiple.', () async {
    await provider.addAllExpenses([
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now()),
      Expense(category: category, cost: Amount(10), createdAt: DateTime.now())
    ]);

    final es = await provider.getEveryExpense();
    final e1 = es[0];
    final e2 = es[1];
    await provider.deleteAllExpenses([e1.id, e2.id]);

    expect(await provider.getEveryExpense(), hasLength(1));
  });
}
