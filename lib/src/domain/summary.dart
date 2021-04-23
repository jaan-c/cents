import 'package:cents/src/domain/amount.dart';

import 'expense.dart';
import 'expense_category.dart';
import 'expense_list_ext.dart';
import 'date_ext.dart';

class Summary {
  final Map<int, YearSummary> yearSummaries;

  Summary._internal(this.yearSummaries);

  factory Summary(List<Expense> expenses) {
    final yearSummaries =
        expenses.groupByYear().map((y, es) => MapEntry(y, YearSummary(y, es)));

    return Summary._internal(yearSummaries);
  }

  MonthSummary? getMonth(int year, int month) {
    return yearSummaries[year]?.monthSummaries[month];
  }
}

class YearSummary {
  final int year;
  final Map<int, MonthSummary> monthSummaries;

  YearSummary._internal(this.year, this.monthSummaries);

  factory YearSummary(int year, List<Expense> expenses) {
    final monthSummaries = expenses
        .groupByMonth()
        .map((m, es) => MapEntry(m, MonthSummary(year, m, es)));

    return YearSummary._internal(year, monthSummaries);
  }
}

class MonthSummary {
  final int year;
  final int month;
  final List<Expense> expenses;

  List<ExpenseCategory> get categories {
    return expenses.map((e) => e.category).toSet().toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  bool get has5thWeek =>
      DateTime(year, month, DateTime(year, month).lastDayOfMonth).weekOfMonth ==
      5;

  MonthSummary(this.year, this.month, this.expenses);

  List<Expense> getBy({ExpenseCategory? category, int? weekOfMonth}) {
    return expenses
        .where((e) =>
            (category == null || e.category == category) &&
            (weekOfMonth == null || e.createdAt.weekOfMonth == weekOfMonth))
        .toList();
  }

  Amount totalCostBy({ExpenseCategory? category, int? weekOfMonth}) {
    return getBy(category: category, weekOfMonth: weekOfMonth).totalCost();
  }
}
