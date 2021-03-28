import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'amount_converter.dart';
import 'database_expense.dart';
import 'expense_category_converter.dart';
import 'expense_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [DatabaseExpense])
@TypeConverters([AmountConverter, ExpenseCategoryConverter])
abstract class AppDatabase extends FloorDatabase {
  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    _instance ??=
        await $FloorAppDatabase.databaseBuilder("app_database.db").build();

    return _instance ?? (throw StateError('Not initialized.'));
  }

  static Future<AppDatabase> getMemoryInstance() async {
    return $FloorAppDatabase.inMemoryDatabaseBuilder().build();
  }

  ExpenseDao get expenseDao;
}
