import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pathlib;

import 'expense_provider.dart';

abstract class DatabaseOpener {
  static const DATABASE_NAME = 'expenses.sql';
  static const DATABASE_VERSION = 1;

  static Future<Database> open() async {
    final path = pathlib.join(await getDatabasesPath(), DATABASE_NAME);

    return await openDatabase(path,
        version: DATABASE_VERSION, onCreate: _initializeExpensesTable);
  }

  static Future<Database> openInMemory() async {
    return await openDatabase(inMemoryDatabasePath,
        version: DATABASE_VERSION, onCreate: _initializeExpensesTable);
  }

  static Future<void> _initializeExpensesTable(Database database, int _) async {
    await database.execute(
      '''
      CREATE TABLE IF NOT EXISTS $TABLE_EXPENSES (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_CATEGORY TEXT NOT NULL,
        $COLUMN_COST INTEGER NOT NULL,
        $COLUMN_CREATED_AT TEXT NOT NULL,
        $COLUMN_NOTE TEXT NOT NULL
      )
      ''',
    );
  }
}
