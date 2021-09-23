import 'package:cents/src/domain/expense_category.dart';

import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/ext_date_time.dart';
import 'package:cents/src/domain/expense_list_ext.dart';
import 'package:cents/src/domain/week_of_month.dart';

class MonthSummary {
  final MonthRange monthRange;
  final List<Expense> expenses;

  List<ExpenseCategory> get categories =>
      expenses.map((e) => e.category).toSet().toList()..sort();

  List<WeekOfMonth> get weeks {
    final lastDayOfMonth =
        DateTime(monthRange.year, monthRange.month).lastDayOfMonth;
    final lastWeekOfMonth =
        DateTime(monthRange.year, monthRange.month, lastDayOfMonth).weekOfMonth;

    return WeekOfMonth.values.take(lastWeekOfMonth.toInt()).toList();
  }

  bool get isEmpty => expenses.isEmpty;
  bool get isNotEmpty => expenses.isNotEmpty;

  MonthSummary(this.monthRange, List<Expense> expenses)
      : assert(expenses.every((e) => monthRange.isInRange(e.createdAt))),
        expenses = List.unmodifiable(expenses);

  List<Expense> getBy({ExpenseCategory? category, WeekOfMonth? weekOfMonth}) {
    return expenses
        .where((e) =>
            (category == null || e.category == category) &&
            (weekOfMonth == null ||
                WeekOfMonth.fromDateTime(e.createdAt) == weekOfMonth))
        .toList();
  }

  Amount totalCostBy({
    ExpenseCategory? category,
    WeekOfMonth? weekOfMonth,
  }) {
    return getBy(category: category, weekOfMonth: weekOfMonth).totalCost();
  }
}
