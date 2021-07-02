import 'dart:ui';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:cents/src/database/database_backup.dart';

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

  test('Import throws FormatException on invalid JSON.', () async {
    final invalidJson = '''
      [
        {
          "category": "Food",
          "cost": 2000,
          "createdAt": "2021-07-01T10:28:53.802101",
          "note": ""
        },
        {
          "category": "Work",
          "cost": 2700,
          "createdAt": "2021-07-01T06:35:08.762756",
          "note": ""
        },
        {
          "category": "Health",
          "cost": 11900,
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": ""
        }invalid here!
      ]
    ''';

    await expectLater(
        () => provider.importFromJson(invalidJson), throwsFormatException);
  });

  test('Import throws FormatException on wrong JSON schema.', () async {
    final wrongType1 = '''
      [
        {
          "category": "Food",
          "cost": 2000,
          "createdAt": "2021-07-01T10:28:53.802101",
          "note": ""
        },
        {
          "category": "Work",
          "cost": 2700,
          "createdAt": "2021-07-01T06:35:08.762756",
          "note": ""
        },
        {
          "category": "Health",
          "cost": "should be int here",
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": ""
        }
      ]
    ''';
    final wrongType2 = '''
      [
        {
          "category": "Health",
          "cost": {},
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": ""
        }
      ]
    ''';

    await expectLater(
        () => provider.importFromJson(wrongType1), throwsFormatException);
    await expectLater(
        () => provider.importFromJson(wrongType2), throwsFormatException);
  });

  test('Import new format.', () async {
    const json = '''
      [
        {
          "category": {
            "name": "Food",
            "color": 4278190335
          },
          "cost": 2000,
          "createdAt": "2021-07-01T10:28:53.802101",
          "note": ""
        },
        {
          "category": {
            "name": "Health",
            "color": 4294901760
          },
          "cost": 11900,
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": "Deodorant"
        },
        {
          "category": {
            "name": "Work",
            "color": 4278255360
          },
          "cost": 2700,
          "createdAt": "2021-07-01T06:35:08.762756",
          "note": ""
        }
      ]
    ''';
    await provider.importFromJson(json);

    final expenses = (await provider.getEveryExpense())
      ..sort((a, b) => a.category.name.compareTo(b.category.name));
    final e1 = expenses[0];
    final e2 = expenses[1];
    final e3 = expenses[2];

    expect(
        e1,
        equalsExpenseContent(Expense(
            category:
                ExpenseCategory(id: 1, name: 'Food', color: Color(0xFF0000FF)),
            cost: Amount(20),
            createdAt: DateTime.parse('2021-07-01T10:28:53.802101'))));
    expect(
        e2,
        equalsExpenseContent(Expense(
            category: ExpenseCategory(
                id: 2, name: 'Health', color: Color(0xFFFF0000)),
            cost: Amount(119),
            createdAt: DateTime.parse('2021-06-26T10:36:30.653267'),
            note: 'Deodorant')));
    expect(
        e3,
        equalsExpenseContent(Expense(
            category:
                ExpenseCategory(id: 3, name: 'Work', color: Color(0xFF00FF00)),
            cost: Amount(27),
            createdAt: DateTime.parse('2021-07-01T06:35:08.762756'))));
  });

  test('Import old format.', () async {
    const json = '''
      [
        {
          "category": "Food",
          "cost": 2000,
          "createdAt": "2021-07-01T10:28:53.802101",
          "note": ""
        },
        {
          "category": "Health",
          "cost": 11900,
          "createdAt": "2021-06-26T10:36:30.653267",
          "note": "Deodorant"
        },
        {
          "category": "Work",
          "cost": 2700,
          "createdAt": "2021-07-01T06:35:08.762756",
          "note": ""
        }
      ]
    ''';
    await provider.importFromJson(json);

    final categories = (await provider.getEveryCategory())
      ..sort((a, b) => a.name.compareTo(b.name));
    final food = categories[0];
    final health = categories[1];
    final work = categories[2];

    final expenses = (await provider.getEveryExpense())
      ..sort((a, b) => a.category.name.compareTo(b.category.name));
    final e1 = expenses[0];
    final e2 = expenses[1];
    final e3 = expenses[2];

    expect(
        e1,
        equalsExpenseContent(Expense(
            category: food,
            cost: Amount(20),
            createdAt: DateTime.parse('2021-07-01T10:28:53.802101'))));
    expect(
        e2,
        equalsExpenseContent(Expense(
            category: health,
            cost: Amount(119),
            createdAt: DateTime.parse('2021-06-26T10:36:30.653267'),
            note: 'Deodorant')));
    expect(
        e3,
        equalsExpenseContent(Expense(
            category: work,
            cost: Amount(27),
            createdAt: DateTime.parse('2021-07-01T06:35:08.762756'))));
  });
}
