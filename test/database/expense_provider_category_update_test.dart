import 'dart:ui';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test('Category update throws AssertionError on unset id.', () async {
    await expectLater(
        () => provider.updateAllCategories([
              ExpenseCategory(
                id: ExpenseCategory.UNSET_ID,
                name: 'Category',
              )
            ]),
        throwsAssertionError);
  });

  test('Category update is no op on non-existent id.', () async {
    final category = ExpenseCategory(
        name: 'Category', color: Color.fromARGB(255, 128, 255, 128));
    await provider.addAllCategories([category]);

    var updatedCategory = (await provider.getEveryCategory()).first;
    final nonExistentId = updatedCategory.id + 1;
    updatedCategory = updatedCategory.copyWith(
        id: nonExistentId,
        name: 'Updated Category',
        color: Color.fromARGB(255, 1, 2, 3));
    await provider.updateAllCategories([updatedCategory]);

    expect(await provider.getCategory(nonExistentId - 1),
        equalsCategoryContent(category));
  });

  test('Category update keeps other records intact.', () async {
    await provider.addAllCategories([
      ExpenseCategory(
          name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
      ExpenseCategory(
          name: 'Category2', color: Color.fromARGB(255, 128, 255, 128))
    ]);

    final categories = (await provider.getEveryCategory())
      ..sort((a, b) => a.id.compareTo(b.id));
    var c1 = categories[0];
    c1 = c1.copyWith(name: 'Category22', color: Color.fromARGB(255, 0, 0, 0));
    await provider.updateAllCategories([c1]);
    final c2 = categories[1];

    expect(await provider.getCategory(c1.id), c1);
    expect(await provider.getCategory(c2.id), c2);
  });

  test('Category update single.', () async {
    final category = ExpenseCategory(
        name: 'Category', color: Color.fromARGB(255, 128, 255, 128));
    await provider.addAllCategories([category]);

    var updatedCategory = (await provider.getEveryCategory()).first;
    updatedCategory = updatedCategory.copyWith(
        name: 'Updated Category', color: Color.fromARGB(255, 1, 2, 3));
    await provider.updateAllCategories([updatedCategory]);

    expect(await provider.getCategory(updatedCategory.id), updatedCategory);
  });

  test('Category update multiple.', () async {
    await provider.addAllCategories([
      ExpenseCategory(
          name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
      ExpenseCategory(
          name: 'Category2', color: Color.fromARGB(255, 128, 255, 128)),
      ExpenseCategory(
          name: 'Category3', color: Color.fromARGB(255, 128, 128, 255)),
    ]);

    final categories = (await provider.getEveryCategory())
      ..sort((a, b) => a.id.compareTo(b.id));
    var c1 = categories[0];
    var c2 = categories[1];
    var c3 = categories[2];
    c1 = c1.copyWith(
        name: 'Category11', color: Color.fromARGB(255, 128, 128, 128));
    c2 = c2.copyWith(
        name: 'Category22', color: Color.fromARGB(255, 128, 128, 128));
    c3 = c3.copyWith(
        name: 'Category33', color: Color.fromARGB(255, 128, 128, 128));
    await provider.updateAllCategories([c1, c2, c3]);

    expect(await provider.getCategory(c1.id), c1);
    expect(await provider.getCategory(c2.id), c2);
    expect(await provider.getCategory(c3.id), c3);
  });
}
