import 'package:floor/floor.dart';

import 'database_expense.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM Expenses ORDER BY createdAt DESC')
  Stream<List<DatabaseExpense>> getAllStream();

  @Query("SELECT * FROM Expenses WHERE id = :id")
  Future<DatabaseExpense?> get(int id);

  @Insert()
  Future<void> insert(DatabaseExpense expense);

  @Query("DELETE FROM Expenses WHERE id = :id")
  Future<void> delete(int id);

  @Update()
  Future<void> update(DatabaseExpense expense);

  @Query(
      "UPDATE Expenses SET category = :newCategory WHERE category = :oldCategory")
  Future<void> renameCategory(String oldCategory, String newCategory);
}
