import 'package:cents/src/domain/expense.dart';

import 'amount.dart';
import 'date_time_range.dart';
import 'expense_category.dart';
import 'expense_list_ext.dart';

class WeekSummary {
  final int year;
  final int weekOfYear;

  final List<Expense> expenses;

  WeekSummary(this.year, this.weekOfYear, List<Expense> expenses)
      : assert(expenses.every((element) =>
            WeekRange.ofYear(year, weekOfYear).isInRange(element.createdAt))),
        expenses = List.unmodifiable(expenses);

  List<Expense> getBy({
    ExpenseCategory? category,
    int? weekday,
  }) {
    return expenses
        .where((e) =>
            (category == null || e.category == category) &&
            (weekday == null || e.createdAt.weekday == weekday))
        .toList();
  }

  Amount totalCostBy({ExpenseCategory? category, int? weekday}) {
    return getBy(category: category, weekday: weekday).totalCost();
  }
}
