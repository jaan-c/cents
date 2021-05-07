import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'column_converter.dart';
import 'database_opener.dart';
import 'row_converter.dart';
import 'utils.dart';

const TABLE_EXPENSES = 'expenses';
const COLUMN_ID = 'id';
const COLUMN_CATEGORY = 'category';
const COLUMN_COST = 'cost';
const COLUMN_CREATED_AT = 'createdAt';
const COLUMN_NOTE = 'note';

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

  Future<List<Expense>> getAllExpenses() async {
    final rows = await _database.query(TABLE_EXPENSES,
        orderBy: '$COLUMN_CREATED_AT DESC');

    final expenses =
        rows.map((r) => r.assertNotNullValues().fromRow()).toList();

    return expenses;
  }

  Future<Expense?> get(int expenseId) async {
    final rows = await _database
        .query(TABLE_EXPENSES, where: '$COLUMN_ID = ?', whereArgs: [expenseId]);

    final expense = rows.firstTry?.assertNotNullValues().fromRow();

    return expense;
  }

  Future<void> add(Expense expense) async {
    assert(expense.id == Expense.UNSET_ID);

    await _database.insert(TABLE_EXPENSES, expense.toRow());

    notifyListeners();
  }

  Future<void> delete(int expenseId) async {
    await _database.delete(TABLE_EXPENSES,
        where: '$COLUMN_ID = ?', whereArgs: [expenseId]);

    notifyListeners();
  }

  Future<void> update(Expense expense) async {
    assert(expense.id != Expense.UNSET_ID);

    await _database.update(TABLE_EXPENSES, expense.toRow(),
        where: '$COLUMN_ID = ?', whereArgs: [expense.id]);

    notifyListeners();
  }

  Future<List<ExpenseCategory>> getAllCategories() async {
    final rows = await _database.query(TABLE_EXPENSES,
        distinct: true,
        columns: [COLUMN_CATEGORY],
        orderBy: '$COLUMN_CATEGORY ASC');

    final categories =
        rows.map((r) => (r[COLUMN_CATEGORY]! as String).toCategory()).toList();

    return categories;
  }

  Future<void> renameCategory(
      ExpenseCategory oldCategory, ExpenseCategory newCategory) async {
    await _database.update(
        TABLE_EXPENSES, {COLUMN_CATEGORY: newCategory.toColumn()},
        where: '$COLUMN_CATEGORY = ?', whereArgs: [oldCategory.name]);

    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _database.close();
    super.dispose();
  }
}
