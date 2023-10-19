import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/foundation.dart';
import 'package:quiver/iterables.dart';
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
        rows.map((r) => r.cast<String, Object>().fromRow()).toList();

    return expenses;
  }

  Future<Expense?> get(int expenseId) async {
    return (await getAll([expenseId])).firstTry;
  }

  Future<List<Expense>> getAll(List<int> expenseIds) async {
    final idsPlaceholder = range(expenseIds.length).map((_) => '?').join(',');
    final rows = await _database.query(TABLE_EXPENSES,
        where: '$COLUMN_ID = ($idsPlaceholder)', whereArgs: expenseIds);

    return rows.map((r) => r.cast<String, Object>().fromRow()).toList();
  }

  Future<void> add(Expense expense) async {
    assert(expense.id == Expense.UNSET_ID);

    await addAll([expense]);
  }

  Future<void> addAll(List<Expense> expenses) async {
    await _execInTransaction(expenses, _execAdd);
    notifyListeners();
  }

  void _execAdd(Batch batch, Expense expense) {
    final row = expense.toRow();
    batch.insert(TABLE_EXPENSES, row);
  }

  Future<void> delete(int expenseId) async {
    await deleteAll([expenseId]);
  }

  Future<void> deleteAll(List<int> expenseIds) async {
    await _execInTransaction(expenseIds, _execDelete);
    notifyListeners();
  }

  void _execDelete(Batch batch, int expenseId) {
    batch.delete(TABLE_EXPENSES,
        where: '$COLUMN_ID = ?', whereArgs: [expenseId]);
  }

  Future<void> update(Expense expense) async {
    assert(expense.id != Expense.UNSET_ID);

    await updateAll([expense]);
  }

  Future<void> updateAll(List<Expense> expenses) async {
    await _execInTransaction(expenses, _execUpdate);
    notifyListeners();
  }

  void _execUpdate(Batch batch, Expense expense) {
    final row = expense.toRow();
    batch.update(TABLE_EXPENSES, row,
        where: '$COLUMN_ID = ?', whereArgs: [expense.id]);
  }

  Future<void> _execInTransaction<T>(
    List<T> values,
    void Function(Batch, T) exec,
  ) async {
    await _database.transaction((txn) async {
      final batch = txn.batch();
      for (var v in values) {
        exec(batch, v);
      }
      await batch.commit(noResult: true, continueOnError: false);
    });
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
