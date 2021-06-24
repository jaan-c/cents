import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'category_crud_converter.dart';
import 'expense_crud_converter.dart';

abstract class ExpenseDatabaseOpener {
  static const DATABASE_NAME = 'expenses.sql';
  static const DATABASE_VERSION = 1;

  static Future<Database> open(
    DatabaseFactory databaseFactory,
    String path,
  ) async {
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: DATABASE_VERSION,
        onCreate: _initDatabase,
      ),
    );
  }

  static Future<Database> openInMemory(
    DatabaseFactory databaseFactory,
  ) async {
    return open(databaseFactoryFfi, inMemoryDatabasePath);
  }

  static Future<void> _initDatabase(Database database, int version) async {
    await database.transaction((txn) async {
      await _initCategoryTable(txn, version);
      await _initExpenseTable(txn, version);
    });
  }

  static Future<void> _initCategoryTable(
    DatabaseExecutor executor,
    int _version,
  ) async {
    await executor.execute(
      '''
      CREATE TABLE IF NOT EXISTS $TABLE_CATEGORIES (
        $CATEGORY_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $CATEGORY_COLUMN_NAME TEXT NOT NULL UNIQUE,
        $CATEGORY_COLUMN_COLOR INTEGER NOT NULL
      )
      ''',
    );
  }

  static Future<void> _initExpenseTable(
    DatabaseExecutor executor,
    int _version,
  ) async {
    await executor.execute(
      '''
      CREATE TABLE IF NOT EXISTS $TABLE_EXPENSES (
        $EXPENSE_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $EXPENSE_COLUMN_CATEGORY INTEGER NOT NULL,
        $EXPENSE_COLUMN_COST INTEGER NOT NULL,
        $EXPENSE_COLUMN_CREATED_AT TEXT NOT NULL,
        $EXPENSE_COLUMN_NOTE TEXT NOT NULL,
        FOREIGN KEY ($EXPENSE_COLUMN_CATEGORY)
          REFERENCES $TABLE_CATEGORIES($CATEGORY_COLUMN_ID)
          ON UPDATE NO ACTION
          ON DELETE NO ACTION
      )
      ''',
    );
  }
}
