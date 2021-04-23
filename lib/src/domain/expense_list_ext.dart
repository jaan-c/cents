import 'package:collection/collection.dart';

import 'amount.dart';
import 'expense.dart';
import 'expense_category.dart';
import 'date_ext.dart';

extension ExpenseListExt on List<Expense> {
  Map<int, List<Expense>> groupByYear() {
    return groupBy(this, (e) => e.createdAt.year);
  }

  Map<int, List<Expense>> groupByMonth() {
    return groupBy(this, (e) => e.createdAt.month);
  }

  Map<int, List<Expense>> groupByWeekOfMonth() {
    return groupBy(this, (e) => e.createdAt.weekOfMonth);
  }

  Map<ExpenseCategory, List<Expense>> groupByCategory() {
    return groupBy(this, (e) => e.category);
  }

  Amount totalCost() {
    return fold(Amount(), (a, e) => a.add(e.cost));
  }

  List<Expense> byMonth(DateTime monthSource) {
    return where((e) =>
        e.createdAt.year == monthSource.year &&
        e.createdAt.month == monthSource.month).toList();
  }

  List<Expense> byWeek(DateTime weekSource) {
    return where((e) =>
        e.createdAt.year == weekSource.year &&
        e.createdAt.weekOfYear == weekSource.weekOfYear).toList();
  }
}
