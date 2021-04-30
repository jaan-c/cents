import 'package:collection/collection.dart';

import 'amount.dart';
import 'expense.dart';
import 'expense_category.dart';
import 'ext_date.dart';
import 'week_of_month.dart';

extension ExpenseListExt on List<Expense> {
  Map<int, List<Expense>> groupByYear() {
    return groupBy(this, (e) => e.createdAt.year);
  }

  Map<int, List<Expense>> groupByMonth() {
    return groupBy(this, (e) => e.createdAt.month);
  }

  Map<WeekOfMonth, List<Expense>> groupByWeekOfMonth() {
    return groupBy(this, (e) => e.createdAt.weekOfMonth);
  }

  Map<ExpenseCategory, List<Expense>> groupByCategory() {
    return groupBy(this, (e) => e.category);
  }

  Amount totalCost() {
    return fold(Amount(), (a, e) => a.add(e.cost));
  }
}
