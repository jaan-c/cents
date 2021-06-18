import 'package:cents/src/domain/expense_category.dart';
import 'package:sqflite/sqflite.dart';

import 'category_crud_converter.dart';

class CategoryCrud {
  static Future<List<ExpenseCategory>> getEverything(
    DatabaseExecutor executor,
  ) async {
    final rows = await executor.query(
      TABLE_CATEGORIES,
      orderBy: '$CATEGORY_COLUMN_NAME ASC',
    );

    return rows.map((r) => rowToCategory(r)).toList();
  }

  static Future<List<ExpenseCategory>> getAll(
    DatabaseExecutor executor,
    Iterable<int> ids,
  ) async {
    assert(ids.every((id) => id != ExpenseCategory.UNSET_ID));

    final idPlaceholders = _tuplePlaceholder(ids.length);
    final rows = await executor.query(
      TABLE_CATEGORIES,
      where: '$CATEGORY_COLUMN_ID IN $idPlaceholders',
      whereArgs: ids.toList(),
      orderBy: '$CATEGORY_COLUMN_NAME ASC',
    );

    return rows.map((r) => rowToCategory(r)).toList();
  }

  static Future<void> addAll(
    DatabaseExecutor executor,
    Iterable<ExpenseCategory> categories,
    ConflictAlgorithm conflictAlgorithm,
  ) async {
    assert(categories.every((c) => c.id == ExpenseCategory.UNSET_ID));

    final batch = executor.batch();
    final rows = categories.map((c) => categoryToRow(c));

    for (final row in rows) {
      batch.insert(TABLE_CATEGORIES, row, conflictAlgorithm: conflictAlgorithm);
    }

    await batch.commit(continueOnError: false, noResult: true);
  }

  static Future<void> updateAll(
    DatabaseExecutor executor,
    Iterable<ExpenseCategory> categories,
    ConflictAlgorithm conflictAlgorithm,
  ) async {
    assert(categories.every((c) => c.id != ExpenseCategory.UNSET_ID));

    final batch = executor.batch();
    final rows = categories.map((c) => categoryToRow(c));

    for (final row in rows) {
      final id = categoryColumnToId(row[CATEGORY_COLUMN_ID]);
      batch.update(
        TABLE_CATEGORIES,
        row,
        where: '$CATEGORY_COLUMN_ID == ?',
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
    assert(ids.every((id) => id != ExpenseCategory.UNSET_ID));

    final idsPlaceholder = _tuplePlaceholder(ids.length);
    await executor.delete(
      TABLE_CATEGORIES,
      where: '$CATEGORY_COLUMN_ID IN $idsPlaceholder',
      whereArgs: ids.toList(),
    );
  }
}

String _tuplePlaceholder(int count) {
  final placeholders = List.filled(count, '?').join(',');
  return '($placeholders)';
}
