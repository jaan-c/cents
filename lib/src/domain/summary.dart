import 'amount.dart';
import 'expense.dart';
import 'expense_category.dart';
import 'expense_list.dart';

class Summary {
  final Map<int, YearSummary> yearSummaries;

  Summary._internal(this.yearSummaries);

  factory Summary.fromExpenses(List<Expense> expenses) {
    final yearSummaries = expenses
        .groupByYear()
        .map((y, es) => MapEntry(y, YearSummary.fromExpenses(es)));

    return Summary._internal(yearSummaries);
  }
}

class YearSummary {
  final Map<int, MonthSummary> monthSummaries;

  YearSummary._internal(this.monthSummaries);

  factory YearSummary.fromExpenses(List<Expense> expenses) {
    final monthSummaries = expenses
        .groupByMonth()
        .map((m, es) => MapEntry(m, MonthSummary.fromExpenses(es)));

    return YearSummary._internal(monthSummaries);
  }
}

class MonthSummary {
  final Map<int, WeekSummary> weekSummaries;

  MonthSummary._internal(this.weekSummaries);

  factory MonthSummary.fromExpenses(List<Expense> expenses) {
    final weekSummaries = expenses
        .groupByWeekOfMonth()
        .map((w, es) => MapEntry(w, WeekSummary.fromExpenses(es)));

    return MonthSummary._internal(weekSummaries);
  }
}

class WeekSummary {
  final Map<ExpenseCategory, CategorySummary> categorySummaries;

  WeekSummary._internal(this.categorySummaries);

  factory WeekSummary.fromExpenses(List<Expense> expenses) {
    final categorySummaries = expenses
        .groupByCategory()
        .map((c, es) => MapEntry(c, CategorySummary.fromExpenses(es)));

    return WeekSummary._internal(categorySummaries);
  }
}

class CategorySummary {
  final List<Expense> expenses;
  final Amount costSum;

  CategorySummary._internal(this.expenses, this.costSum);

  factory CategorySummary.fromExpenses(List<Expense> expenses) {
    return CategorySummary._internal(expenses, expenses.sum());
  }
}
