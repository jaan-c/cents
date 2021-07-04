import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pathlib;

import 'expense_database_opener.dart';
import 'expense_crud.dart';
import 'category_crud.dart';

class ExpenseProvider with ChangeNotifier {
  static const DATABASE_NAME = 'expenses.sql';
  static const DATABASE_VERSION = 1;

  static Future<ExpenseProvider> open({
    DatabaseFactory? defaultDatabaseFactory,
    String path = '',
  }) async {
    defaultDatabaseFactory ??= databaseFactory;
    path = path.isNotEmpty
        ? path
        : pathlib.join(await getDatabasesPath(), DATABASE_NAME);

    final database =
        await ExpenseDatabaseOpener.open(defaultDatabaseFactory, path);
    return ExpenseProvider(database);
  }

  static Future<ExpenseProvider> openInMemory({
    DatabaseFactory? defaultDatabaseFactory,
  }) async {
    return ExpenseProvider.open(
        defaultDatabaseFactory: defaultDatabaseFactory,
        path: inMemoryDatabasePath);
  }

  final Database _database;

  ExpenseProvider(this._database);

  @override
  Future<void> dispose() async {
    await _database.close();
    super.dispose();
  }

  Future<List<ExpenseCategory>> getEveryCategory() async {
    return CategoryCrud.getEverything(_database);
  }

  Future<List<ExpenseCategory>> getAllCategories(
    Iterable<int> categoryIds,
  ) async {
    return CategoryCrud.getAll(_database, categoryIds);
  }

  Future<List<ExpenseCategory>> getAllCategoriesByName(
    Iterable<String> categoryNames,
  ) async {
    return CategoryCrud.getAllByName(_database, categoryNames);
  }

  Future<ExpenseCategory?> getCategory(int categoryId) async {
    final categories = await CategoryCrud.getAll(_database, [categoryId]);

    if (categories.isNotEmpty) {
      return categories.first;
    }
  }

  Future<ExpenseCategory?> getCategoryByName(String categoryName) async {
    final categories =
        await CategoryCrud.getAllByName(_database, [categoryName]);

    if (categories.isNotEmpty) {
      return categories.first;
    }
  }

  Future<void> addAllCategories(Iterable<ExpenseCategory> categories) async {
    await _database.transaction((txn) async {
      await CategoryCrud.addAll(txn, categories, ConflictAlgorithm.abort);
    });

    notifyListeners();
  }

  Future<void> updateAllCategories(
    Iterable<ExpenseCategory> categories,
  ) async {
    await _database.transaction((txn) async {
      await CategoryCrud.updateAll(txn, categories, ConflictAlgorithm.abort);
    });

    notifyListeners();
  }

  Future<void> deleteAllCategories(Iterable<int> categoryIds) async {
    await _database.transaction((txn) async {
      await CategoryCrud.deleteAll(txn, categoryIds);
    });

    notifyListeners();
  }

  Future<List<Expense>> getEveryExpense() async {
    return ExpenseCrud.getEverything(_database);
  }

  Future<List<Expense>> getAllExpenses(Iterable<int> expenseIds) async {
    return ExpenseCrud.getAll(_database, expenseIds);
  }

  Future<Expense?> getExpense(int expenseId) async {
    final expenses = await ExpenseCrud.getAll(_database, [expenseId]);

    if (expenses.isNotEmpty) {
      return expenses.first;
    }
  }

  /// Stores all [expenses] with existing categories.
  Future<void> addAllExpenses(Iterable<Expense> expenses) async {
    assert(expenses.every((e) => e.id == Expense.UNSET_ID));

    await _database.transaction((txn) async {
      final existingCategories = await CategoryCrud.getEverything(txn);
      _checkCategoriesExist(expenses, existingCategories);

      await ExpenseCrud.addAll(txn, expenses, ConflictAlgorithm.abort);
    });

    notifyListeners();
  }

  Future<void> updateAllExpenses(Iterable<Expense> expenses) async {
    await _database.transaction((txn) async {
      final existingCategories = await CategoryCrud.getEverything(txn);
      _checkCategoriesExist(expenses, existingCategories);

      await ExpenseCrud.updateAll(txn, expenses, ConflictAlgorithm.abort);
    });

    notifyListeners();
  }

  /// Check if all categories with set id of each [expense] does exist in
  /// [existingCategories].
  void _checkCategoriesExist(
    Iterable<Expense> expenses,
    Iterable<ExpenseCategory> existingCategories,
  ) {
    final categories = expenses.map((e) => e.category);
    final idCategories =
        Map.fromEntries(existingCategories.map((c) => MapEntry(c.id, c)));

    for (final category in categories) {
      assert(category.id != ExpenseCategory.UNSET_ID);

      if (category != idCategories[category.id]) {
        throw StateError(
            'Attempting to add/update non-existent category "${category.name}".');
      }
    }
  }

  Future<void> deleteAllExpenses(Iterable<int> expenseIds) async {
    await _database.transaction((txn) async {
      await ExpenseCrud.deleteAll(txn, expenseIds);
    });

    notifyListeners();
  }
}
