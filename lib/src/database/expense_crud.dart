import 'package:cents/src/domain/expense.dart';
import 'package:sqflite/sqflite.dart';

import 'amount_range.dart';
import 'category_crud.dart';
import 'date_time_range.dart';
import 'expense_crud_converter.dart';
import 'category_crud_converter.dart';

class ExpenseCrud {
  static Future<List<Expense>> getEverything(DatabaseExecutor executor) async {
    final categories = await CategoryCrud.getEverything(executor);
    final idCategories =
        Map.fromEntries(categories.map((c) => MapEntry(c.id, c)));

    final rows = await executor.query(TABLE_EXPENSES);

    return rows.map((r) {
      final categoryId = expenseColumnToId(r[EXPENSE_COLUMN_CATEGORY]);
      return rowToExpense(r, idCategories[categoryId]!);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<List<Expense>> getBy(
    DatabaseExecutor executor, {
    String? categoryName,
    AmountRange? costRange,
    DateTimeRange? createdAtRange,
    String? noteKeyword,
  }) async {
    final categoryCondition = categoryName == null
        ? 'TRUE'
        : '''
          columnName = ?
        ''';
    final costRangeCondition = costRange == null
        ? 'TRUE'
        : '''
          $EXPENSE_COLUMN_COST 
          BETWEEN ${costRange.start.totalCents} AND ${costRange.end.totalCents}
        ''';
    final createdAtRangeCondition = createdAtRange == null
        ? 'TRUE'
        : '''
          DATETIME($EXPENSE_COLUMN_CREATED_AT) 
          BETWEEN DATETIME("${createdAtRange.start.toIso8601String()}") 
            AND DATETIME("${createdAtRange.end.toIso8601String()}")
        ''';
    final noteKeywordCondition = noteKeyword == null
        ? 'TRUE'
        : '''
          $EXPENSE_COLUMN_NOTE LIKE ?
        ''';

    final rows = await executor.rawQuery('''
      SELECT 
          $TABLE_EXPENSES.*,
          $TABLE_CATEGORIES.$CATEGORY_COLUMN_ID as columnId,
          $TABLE_CATEGORIES.$CATEGORY_COLUMN_NAME AS columnName 
        FROM $TABLE_EXPENSES 
        JOIN $TABLE_CATEGORIES 
        ON $TABLE_EXPENSES.$EXPENSE_COLUMN_CATEGORY = columnId
      WHERE
        ($categoryCondition)
        AND ($costRangeCondition)
        AND ($createdAtRangeCondition)
        AND ($noteKeywordCondition)
      ''', [
      if (categoryName != null) categoryName,
      if (noteKeyword != null) '%$noteKeyword%',
    ]);

    final categories = await CategoryCrud.getEverything(executor);
    final idCategories =
        Map.fromEntries(categories.map((c) => MapEntry(c.id, c)));

    return rows.map((r) {
      final categoryId = expenseColumnToId(r[EXPENSE_COLUMN_CATEGORY]);
      return rowToExpense(r, idCategories[categoryId]!);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
