import 'dart:ui';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late ExpenseProvider provider;

  setUp(() async {
    sqfliteFfiInit();

    provider = await ExpenseProvider.openInMemory(
        defaultDatabaseFactory: databaseFactoryFfi);
  });

  tearDown(() async {
    await provider.dispose();
  });

  test('Category delete throws AssertionError on unset id.', () async {
    await expectLater(
        () => provider.deleteAllCategories([ExpenseCategory.UNSET_ID]),
        throwsAssertionError);
  });

  test('Category delete is no op on non-existent id.', () async {
    await provider.addAllCategories([
      ExpenseCategory(
          name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
      ExpenseCategory(
          name: 'Category2', color: Color.fromARGB(255, 128, 255, 128)),
      ExpenseCategory(
          name: 'Category3', color: Color.fromARGB(255, 128, 128, 255)),
    ]);

    final categories = await provider.getEveryCategory();
    final nonExistentId = categories.fold<int>(0, (acc, c) => acc + c.id);
    await provider.deleteAllCategories([nonExistentId]);

    expect(await provider.getEveryCategory(), hasLength(3));
  });

  test('Category delete single.', () async {
    await provider.addAllCategories([
      ExpenseCategory(
          name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
      ExpenseCategory(
          name: 'Category2', color: Color.fromARGB(255, 128, 255, 128)),
      ExpenseCategory(
          name: 'Category3', color: Color.fromARGB(255, 128, 128, 255)),
    ]);

    final categories = await provider.getEveryCategory();
    await provider.deleteAllCategories([categories.first.id]);

    expect(await provider.getEveryCategory(), hasLength(2));
  });

  test('Category delete multiple.', () async {
    await provider.addAllCategories([
      ExpenseCategory(
          name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
      ExpenseCategory(
          name: 'Category2', color: Color.fromARGB(255, 128, 255, 128)),
      ExpenseCategory(
          name: 'Category3', color: Color.fromARGB(255, 128, 128, 255)),
    ]);

    final categories = await provider.getEveryCategory();
    await provider.deleteAllCategories([categories[0].id, categories[1].id]);

    expect(await provider.getEveryCategory(), hasLength(1));
  });
}
