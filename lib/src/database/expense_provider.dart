import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'database_opener.dart';
import 'expense_crud.dart';
import 'category_crud.dart';

class ExpenseProvider with ChangeNotifier {
  static Future<ExpenseProvider> open() async {
    final database = await DatabaseOpener.open();
    return ExpenseProvider(database);
  }

  static Future<ExpenseProvider> openInMemory() async {
    final database = await DatabaseOpener.openInMemory();
    return ExpenseProvider(database);
  }

  final Database _database;

  ExpenseProvider(this._database);

  @override
  Future<void> dispose() async {
    await _database.close();
    super.dispose();
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

  /// Stores all [expenses].
  ///
  /// All [ExpenseCategory] with [ExpenseCategory.UNSET_ID] are stored
  /// automatically before the expenses and ones with set id are checked against
  /// stored categories, and throws a [StateError] if they don't match any.
  Future<void> addAllExpenses(Iterable<Expense> expenses) async {
    await _database.transaction((txn) async {
      final existingCategories = await CategoryCrud.getEverything(txn);
      _checkCategoriesExist(expenses, existingCategories);

      await _addNewCategories(txn, expenses, ConflictAlgorithm.abort);
      await ExpenseCrud.addAll(txn, expenses, ConflictAlgorithm.abort);
    });

    notifyListeners();
  }

  Future<void> updateAllExpenses(Iterable<Expense> expenses) async {
    await _database.transaction((txn) async {
      final existingCategories = await CategoryCrud.getEverything(txn);
      _checkCategoriesExist(expenses, existingCategories);

      await _addNewCategories(txn, expenses, ConflictAlgorithm.abort);
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
    final categoriesWithId = expenses
        .map((e) => e.category)
        .where((c) => c.id != ExpenseCategory.UNSET_ID);
    final idExistingCategories =
        Map.fromEntries(existingCategories.map((c) => MapEntry(c.id, c)));

    for (final category in categoriesWithId) {
      if (category != idExistingCategories[category.id]) {
        throw StateError(
            'Attempting to add/update non-existent category "${category.name}"');
      }
    }
  }

  Future<void> _addNewCategories(
    DatabaseExecutor executor,
    Iterable<Expense> expenses,
    ConflictAlgorithm conflictAlgorithm,
  ) async {
    final newCategories = expenses
        .map((e) => e.category)
        .where((c) => c.id == ExpenseCategory.UNSET_ID)
        .toSet();

    await CategoryCrud.addAll(
      executor,
      newCategories,
      conflictAlgorithm,
    );
  }

  Future<void> deleteAllExpenses(Iterable<int> expenseIds) async {
    await _database.transaction((txn) async {
      await ExpenseCrud.deleteAll(txn, expenseIds);
    });

    notifyListeners();
  }

  Future<List<ExpenseCategory>> getEveryCategory() async {
    return CategoryCrud.getEverything(_database);
  }

  Future<List<ExpenseCategory>> getAllCategories(
    Iterable<int> categoryIds,
  ) async {
    return CategoryCrud.getAll(_database, categoryIds);
  }

  Future<ExpenseCategory?> getCategory(int categoryId) async {
    final categories = await CategoryCrud.getAll(_database, [categoryId]);

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
}
