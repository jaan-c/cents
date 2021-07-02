import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher equalsCategoryContent(ExpenseCategory category) {
  return allOf(
    predicate(
      (c) => (c as ExpenseCategory).name == category.name,
      category.name,
    ),
    predicate(
      (c) => (c as ExpenseCategory).color == category.color,
      category.color.toString(),
    ),
  );
}

Matcher equalsExpenseContent(Expense expense) {
  return allOf(
    predicate(
      (e) => (e as Expense).category == expense.category,
      expense.category.toString(),
    ),
    predicate(
      (e) => (e as Expense).cost == expense.cost,
      expense.cost.toString(),
    ),
    predicate(
      (e) => (e as Expense).createdAt == expense.createdAt,
      expense.createdAt.toIso8601String(),
    ),
    predicate(
      (e) => (e as Expense).note == expense.note,
      expense.note.toString(),
    ),
  );
}
