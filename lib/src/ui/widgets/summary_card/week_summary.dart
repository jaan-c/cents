import 'package:cents/src/domain/expense.dart';

import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/expense_list_ext.dart';

class WeekSummary {
  final int year;
  final int weekOfYear;

  final List<Expense> expenses;

  List<ExpenseCategory> get categories =>
      expenses.map((e) => e.category).toSet().toList()..sort();

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
