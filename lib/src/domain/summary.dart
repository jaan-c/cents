import 'package:cents/src/domain/amount.dart';
import 'package:quiver/iterables.dart';

import 'expense.dart';
import 'expense_category.dart';
import 'expense_list_ext.dart';
import 'ext_date_time.dart';
import 'week_of_month.dart';

class Summary {
  final Map<int, YearSummary> _yearSummaries;

  Summary._internal(this._yearSummaries);

  factory Summary(List<Expense> expenses) {
    final yearSummaries =
        expenses.groupByYear().map((y, es) => MapEntry(y, YearSummary(y, es)));

    return Summary._internal(yearSummaries);
  }

  List<int> getAllYears() {
    return _yearSummaries.keys.toList()..sort();
  }

  List<YearSummary> getAllYearSummaries() {
    return getAllYears().map((y) => getYearSummary(y)!).toList();
  }

  bool hasYear(int year) {
    return getYearSummary(year) != null;
  }

  bool hasMonth(int year, int month) {
    return getMonthSummary(year, month) != null;
  }

  int? getClosestOldestYear(int fromYear) {
    final years = getAllYears();
    final distances = years.map((y) => (y - fromYear).abs());
    final yearDistances = Map.fromEntries(
        zip([years, distances]).map((yd) => MapEntry(yd[0], yd[1])));

    if (yearDistances.isEmpty) {
      return null;
    }

    final lowestDistance = min(yearDistances.values)!;
    final closestYears = yearDistances.entries
        .where((e) => e.value == lowestDistance)
        .map((e) => e.key);

    return min(closestYears)!;
  }

  YearSummary? getYearSummary(int year) {
    return _yearSummaries[year];
  }

  MonthSummary? getMonthSummary(int year, int month) {
    return getYearSummary(year)?.getMonthSummary(month);
  }
}

class YearSummary {
  final int year;

  final Map<int, MonthSummary> _monthSummaries;

  YearSummary._internal(this.year, this._monthSummaries);

  factory YearSummary(int year, List<Expense> expenses) {
    final monthSummaries = expenses
        .groupByMonth()
        .map((m, es) => MapEntry(m, MonthSummary(year, m, es)));

    return YearSummary._internal(year, monthSummaries);
  }

  List<int> getAllMonths() {
    return _monthSummaries.keys.toList()..sort();
  }

  List<MonthSummary> getAllMonthSummaries() {
    return getAllMonths().map((m) => getMonthSummary(m)!).toList();
  }

  MonthSummary? getMonthSummary(int month) {
    return _monthSummaries[month];
  }
}

class MonthSummary {
  final int year;
  final int month;

  final List<Expense> _expenses;

  MonthSummary(this.year, this.month, this._expenses);

  bool isEmpty() {
    return _expenses.isEmpty;
  }

  bool isNotEmpty() {
    return !isEmpty();
  }

  List<Expense> getAllExpenses() {
    return List.of(_expenses);
  }

  List<ExpenseCategory> getAllCategories() {
    return getAllExpenses().map((e) => e.category).toSet().toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<WeekOfMonth> getAllWeeks() {
    final lastDayOfMonth = DateTime(year, month).lastDayOfMonth;
    final lastWeekOfMonth = DateTime(year, month, lastDayOfMonth).weekOfMonth;

    return WeekOfMonth.values.take(lastWeekOfMonth.toInt()).toList();
  }

  List<Expense> getBy({
    ExpenseCategory? category,
    WeekOfMonth? weekOfMonth,
    int? dayOfWeek,
  }) {
    return getAllExpenses()
        .where((e) =>
            (category == null || e.category == category) &&
            (weekOfMonth == null || e.createdAt.weekOfMonth == weekOfMonth) &&
            (dayOfWeek == null || e.createdAt.weekday == dayOfWeek))
        .toList();
  }

  Amount totalCostBy({
    ExpenseCategory? category,
    WeekOfMonth? weekOfMonth,
    int? dayOfWeek,
  }) {
    return getBy(
            category: category, weekOfMonth: weekOfMonth, dayOfWeek: dayOfWeek)
        .totalCost();
  }
}
