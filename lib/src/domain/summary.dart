import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:quiver/iterables.dart';
import 'package:quiver/time.dart';

import 'amount.dart';
import 'expense.dart';
import 'ext_date_time.dart';
import 'expense_list_ext.dart';

class Summary {
  final List<Expense> _expenses;

  List<Expense> get expenses => _expenses.toList();

  List<int> get years {
    final allYears = expenses.map((e) => e.createdAt.year).toList();
    if (allYears.isEmpty) {
      return [];
    }

    final startYear = min(allYears)!;
    final endYear = max(allYears)!;

    return range(startYear, endYear + 1).cast<int>().toList();
  }

  List<YearSummary> get yearSummaries =>
      years.map((y) => YearSummary(y, expenses)).toList();

  bool get isEmpty => expenses.isEmpty;
  bool get isNotEmpty => expenses.isNotEmpty;

  Summary(this._expenses);

  YearSummary getYearSummary(int year) {
    return YearSummary(year, expenses);
  }

  MonthSummary getMonthSummary(int year, int month) {
    return MonthSummary(year, month, expenses);
  }
}

class YearSummary {
  final int year;

  final List<Expense> _expenses;

  List<Expense> get expenses => _expenses.toList();

  List<int> get months =>
      range(DateTime.january, DateTime.december + 1).cast<int>().toList();

  List<MonthSummary> get monthSummaries =>
      months.map((m) => MonthSummary(year, m, expenses)).toList();

  bool get isEmpty => expenses.isEmpty;
  bool get isNotEmpty => expenses.isNotEmpty;

  YearSummary._internal(this.year, this._expenses);

  factory YearSummary(int year, List<Expense> expenses) {
    final startOfYear = DateTime(year, DateTime.january, 1);
    final endOfYear = DateTime(year + 1, DateTime.january, 1).subtract(aDay);

    expenses = _filterExpenseByDateTimeRange(expenses, startOfYear, endOfYear);

    return YearSummary._internal(year, expenses);
  }

  MonthSummary getMonthSummary(int month) {
    return MonthSummary(year, month, expenses);
  }
}

class MonthSummary {
  final int year;
  final int month;

  final List<Expense> _expenses;

  List<Expense> get expenses => _expenses.toList();

  List<ExpenseCategory> get categories =>
      expenses.map((e) => e.category).toSet().toList()..sort();

  List<WeekOfMonth> get weeks {
    final lastDayOfMonth = DateTime(year, month).lastDayOfMonth;
    final lastWeekOfMonth = DateTime(year, month, lastDayOfMonth).weekOfMonth;

    return WeekOfMonth.values.take(lastWeekOfMonth.toInt()).toList();
  }

  bool get isEmpty => expenses.isEmpty;
  bool get isNotEmpty => expenses.isNotEmpty;

  MonthSummary._internal(this.year, this.month, this._expenses);

  factory MonthSummary(int year, int month, List<Expense> expenses) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth =
        DateTime(year, month, DateTime(year, month).lastDayOfMonth);

    expenses =
        _filterExpenseByDateTimeRange(expenses, startOfMonth, endOfMonth);

    return MonthSummary._internal(year, month, expenses);
  }

  List<Expense> getBy({
    ExpenseCategory? category,
    WeekOfMonth? weekOfMonth,
    int? dayOfWeek,
  }) {
    return expenses
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

List<Expense> _filterExpenseByDateTimeRange(
  List<Expense> expenses,
  DateTime startDateTime,
  DateTime endDateTime,
) {
  return expenses
      .where((e) => _isDateTimeInRange(e.createdAt, startDateTime, endDateTime))
      .toList();
}

bool _isDateTimeInRange(DateTime dateTime, DateTime start, DateTime end) {
  final dateTimeMsEpoch = dateTime.millisecondsSinceEpoch;
  final startMsEpoch = start.millisecondsSinceEpoch;
  final endMsEpoch = end.millisecondsSinceEpoch;

  return startMsEpoch <= dateTimeMsEpoch && dateTimeMsEpoch <= endMsEpoch;
}
