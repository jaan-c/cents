import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';

import 'app_database.dart';
import 'database_expense.dart';
import 'expense_dao.dart';

class ExpenseRepo {
  final AppDatabase _database;

  ExpenseDao get _dao => _database.expenseDao;

  Stream<List<Expense>> get expensesStream => _dao
      .getAllStream()
      .map((dbExpenses) => dbExpenses.map((de) => de.asDomain()).toList());

  Stream<List<ExpenseCategory>> get categoriesStream =>
      _dao.getAllStream().map((dbExpenses) =>
          dbExpenses.map((de) => de.asDomain().category).toSet().toList());

  ExpenseRepo(this._database);

  Future<Expense?> get(int id) async {
    return (await _dao.get(id))?.asDomain();
  }

  Future<void> add(Expense expense) async {
    await _dao.insert(DatabaseExpense.fromDomain(expense));
  }

  Future<void> delete(int id) async {
    await _dao.delete(id);
  }

  Future<void> update(Expense expense) async {
    await _dao.update(DatabaseExpense.fromDomain(expense));
  }

  Future<void> renameCategory(
      ExpenseCategory oldCategory, ExpenseCategory newCategory) async {
    await _dao.renameCategory(oldCategory.name, newCategory.name);
  }
}
