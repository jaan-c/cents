import 'package:floor/floor.dart';

import 'database_expense.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM Expenses')
  Future<List<DatabaseExpense>> getAllExpenses();

  @Query('SELECT * FROM Expenses')
  Stream<List<DatabaseExpense>> getAllExpensesStream();

  @Insert()
  Future<void> insert(DatabaseExpense expense);
}
