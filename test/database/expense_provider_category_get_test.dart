import 'dart:ui';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils.dart';

void main() {
  late ExpenseProvider provider;
  final categories = [
    ExpenseCategory(
        name: 'Category1', color: Color.fromARGB(255, 255, 128, 128)),
    ExpenseCategory(
        name: 'Category2', color: Color.fromARGB(255, 128, 255, 128)),
    ExpenseCategory(
        name: 'Category3', color: Color.fromARGB(255, 128, 128, 255)),
    ExpenseCategory(
        name: 'Category4', color: Color.fromARGB(255, 50, 100, 150)),
    ExpenseCategory(name: 'Category5', color: Color.fromARGB(255, 25, 50, 75)),
  ];

  setUp(() async {
    sqfliteFfiInit();

    provider = await ExpenseProvider.openInMemory(
        defaultDatabaseFactory: databaseFactoryFfi);

    await provider.addAllCategories(categories);
  });

  tearDown(() async {
    await provider.dispose();
  });

  test('Category get throws AssertionError unset id.', () async {
    await expectLater(() => provider.getCategory(ExpenseCategory.UNSET_ID),
        throwsAssertionError);
    await expectLater(
        () => provider.getAllCategories(
            [ExpenseCategory.UNSET_ID, ExpenseCategory.UNSET_ID]),
        throwsAssertionError);
  });

  test('Category get by name throws AssertionError on empty names.', () async {
    await expectLater(
        () => provider.getCategoryByName(''), throwsAssertionError);
    await expectLater(
        () => provider.getAllCategoriesByName(['', '']), throwsAssertionError);
  });

  test('Categoy get returns null on non-existent id.', () async {
    final categories = await provider.getEveryCategory();
    final nonExistentId = categories.fold<int>(0, (acc, c) => acc + c.id);

    expect(await provider.getCategory(nonExistentId), isNull);
  });

  test('Category get single.', () async {
    final categories = await provider.getEveryCategory();

    final c1 = categories[0];
    expect(await provider.getCategory(c1.id), c1);
    expect(await provider.getCategoryByName(c1.name), c1);
  });

  test('Category get multiple.', () async {
    final categories = (await provider.getEveryCategory())
      ..sort((a, b) => a.id.compareTo(b.id));

    final c1 = categories[0];
    final c2 = categories[1];
    expect(
        (await provider.getAllCategories([c1.id, c2.id]))
          ..sort((a, b) => a.id.compareTo(b.id)),
        equals([c1, c2]));
    expect(
        (await provider.getAllCategoriesByName([c1.name, c2.name]))
          ..sort((a, b) => a.name.compareTo(b.name)),
        equals([c1, c2]));
  });

  test('Category get everything.', () async {
    final cs = (await provider.getEveryCategory())
      ..sort((a, b) => a.id.compareTo(b.id));

    expect(cs[0], equalsCategoryContent(categories[0]));
    expect(cs[1], equalsCategoryContent(categories[1]));
    expect(cs[2], equalsCategoryContent(categories[2]));
    expect(cs[3], equalsCategoryContent(categories[3]));
    expect(cs[4], equalsCategoryContent(categories[4]));
  });
}
