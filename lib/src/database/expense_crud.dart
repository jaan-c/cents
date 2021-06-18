import 'package:cents/src/domain/expense.dart';
import 'package:sqflite/sqflite.dart';

import 'category_crud.dart';
import 'expense_crud_converter.dart';

class ExpenseCrud {
  static Future<List<Expense>> getEverything(DatabaseExecutor executor) async {
    final categories = await CategoryCrud.getEverything(executor);
    final idCategories =
        Map.fromEntries(categories.map((c) => MapEntry(c.id, c)));

    final rows = await executor.query(TABLE_EXPENSES);

    return rows.map((r) {
      final categoryId = expenseColumnToId(r[EXPENSE_COLUMN_CATEGORY]);
      return rowToExpense(r, idCategories[categoryId]!);
    }).toList();
  }

  static Future<List<Expense>> getAll(
    DatabaseExecutor executor,
    Iterable<int> ids,
  ) async {
    assert(ids.every((id) => id != Expense.UNSET_ID));

    final categories = await CategoryCrud.getEverything(executor);
    final idCategories =
        Map.fromEntries(categories.map((c) => MapEntry(c.id, c)));

    final idPlaceholders = _tuplePlaceholder(ids.length);
    final rows = await executor.query(
      TABLE_EXPENSES,
      where: '$EXPENSE_COLUMN_ID in $idPlaceholders',
      whereArgs: ids.toList(),
    );

    return rows.map((r) {
      final categoryId = expenseColumnToId(r[EXPENSE_COLUMN_CATEGORY]);
      return rowToExpense(r, idCategories[categoryId]!);
    }).toList();
  }

  static Future<void> addAll(
    DatabaseExecutor executor,
    Iterable<Expense> expenses,
    ConflictAlgorithm conflictAlgorithm,
  ) async {
    assert(expenses.every((e) => e.id == Expense.UNSET_ID));

    final batch = executor.batch();
    final rows = expenses.map((e) => expenseToRow(e));

    for (final row in rows) {
      batch.insert(TABLE_EXPENSES, row, conflictAlgorithm: conflictAlgorithm);
    }

    await batch.commit(continueOnError: false, noResult: true);
  }

  static Future<void> updateAll(
    DatabaseExecutor executor,
    Iterable<Expense> expenses,
    ConflictAlgorithm conflictAlgorithm,
  ) async {
    assert(expenses.every((e) => e.id != Expense.UNSET_ID));

    final batch = executor.batch();
    final rows = expenses.map((e) => expenseToRow(e));

    for (final row in rows) {
      final id = expenseColumnToId(row[EXPENSE_COLUMN_ID]);
      batch.update(
        TABLE_EXPENSES,
        row,
        where: '$EXPENSE_COLUMN_ID == ?',
        whereArgs: [id],
        conflictAlgorithm: conflictAlgorithm,
      );
    }

    await batch.commit(continueOnError: false, noResult: true);
  }

  static Future<void> deleteAll(
    DatabaseExecutor executor,
    Iterable<int> ids,
  ) async {
    assert(ids.every((id) => id != Expense.UNSET_ID));

    final idPlaceholders = _tuplePlaceholder(ids.length);
    await executor.delete(
      TABLE_EXPENSES,
      where: '$EXPENSE_COLUMN_ID IN $idPlaceholders',
      whereArgs: ids.toList(),
    );
  }
}

String _tuplePlaceholder(int count) {
  final placeholders = List.filled(count, '?').join(',');
  return '($placeholders)';
}
