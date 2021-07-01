import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher equalsCategoryContent(ExpenseCategory category) {
  return allOf(
    predicate(
      (c) => (c as ExpenseCategory).name == category.name,
      'Category name matches',
    ),
    predicate(
      (c) => (c as ExpenseCategory).color == category.color,
      'Category color matches',
    ),
  );
}

Matcher equalsExpenseContent(Expense expense) {
  return allOf(
    predicate(
      (e) => (e as Expense).category == expense.category,
      'Expense category matches',
    ),
    predicate(
      (e) => (e as Expense).cost == expense.cost,
      'Expense cost matches',
    ),
    predicate(
      (e) => (e as Expense).createdAt == expense.createdAt,
      'Expense createdAt matches',
    ),
    predicate(
      (e) => (e as Expense).note == expense.note,
      'Expense note matches',
    ),
  );
}
