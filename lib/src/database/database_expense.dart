import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:floor/floor.dart';

@Entity(tableName: "Expenses")
class DatabaseExpense {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final Amount cost;
  final ExpenseCategory category;
  final DateTime createdAt;
  final String note;

  DatabaseExpense(this.id, this.cost, this.category, this.createdAt, this.note);

  DatabaseExpense.fromDomain(Expense expense)
      : this(expense.id, expense.cost, expense.category, expense.createdAt,
            expense.note);

  Expense asDomain() {
    return Expense(
        id: id,
        cost: cost,
        category: category,
        createdAt: createdAt,
        note: note);
  }
}
