import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqlite_api.dart' show DatabaseException;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils.dart';

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

  test('Category add throws AssertionError on set id.', () async {
    await expectLater(
        () => provider.addAllCategories([
              ExpenseCategory(
                  id: 1,
                  name: 'Category',
                  color: Color.fromARGB(255, 128, 255, 128))
            ]),
        throwsAssertionError);
  });

  test('Category add throws DatabaseException on duplicate name', () async {
    final category = ExpenseCategory(
        name: 'Category', color: Color.fromARGB(255, 255, 128, 128));
    final duplicateCategory = ExpenseCategory(
        name: 'Category', color: Color.fromARGB(255, 128, 255, 128));

    await provider.addAllCategories([category]);

    await expectLater(() => provider.addAllCategories([duplicateCategory]),
        throwsA(isInstanceOf<DatabaseException>()));
  });

  test('Category add single.', () async {
    final category = ExpenseCategory(
        name: 'Category', color: Color.fromARGB(255, 128, 255, 128));

    await provider.addAllCategories([category]);

    final categories = await provider.getEveryCategory();
    final c = categories.first;
    expect(c.id, isNot(ExpenseCategory.UNSET_ID));
    expect(c, equalsCategoryContent(category));
    expect(categories, hasLength(1));
  });

  test('Category add multiple', () async {
    final category1 = ExpenseCategory(
        name: 'Category1', color: Color.fromARGB(255, 255, 128, 128));
    final category2 = ExpenseCategory(
        name: 'Category2', color: Color.fromARGB(255, 128, 255, 128));
    final category3 = ExpenseCategory(
        name: 'Category3', color: Color.fromARGB(255, 128, 128, 255));

    await provider.addAllCategories([category1, category2, category3]);

    final categories = (await provider.getEveryCategory())
      ..sort((a, b) => a.id.compareTo(b.id));
    final c1 = categories[0];
    final c2 = categories[1];
    final c3 = categories[2];
    expect([c1, c2, c3], everyElement(isNot(ExpenseCategory.UNSET_ID)));
    expect(c1, equalsCategoryContent(category1));
    expect(c2, equalsCategoryContent(category2));
    expect(c3, equalsCategoryContent(category3));
    expect(categories, hasLength(3));
  });
}
