import 'dart:ui';

import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';

const JSON_EXPENSE_CATEGORY = 'category';
const JSON_EXPENSE_COST = 'cost';
const JSON_EXPENSE_CREATED_AT = 'createdAt';
const JSON_EXPENSE_NOTE = 'note';

const JSON_CATEGORY_NAME = 'name';
const JSON_CATEGORY_COLOR = 'color';

Map<String, Object> expenseToObject(Expense expense) {
  return {
    JSON_EXPENSE_CATEGORY: {
      JSON_CATEGORY_NAME: expense.category.name,
      JSON_CATEGORY_COLOR: expense.category.color.value,
    },
    JSON_EXPENSE_COST: expense.cost.totalCents,
    JSON_EXPENSE_CREATED_AT: expense.createdAt.toIso8601String(),
    JSON_EXPENSE_NOTE: expense.note,
  };
}

Expense objectToExpense(
  Map<String, Object> object, {
  required int id,
  required int categoryId,
}) {
  final categoryObject = object[JSON_EXPENSE_CATEGORY] as Map<String, Object>;
  final category = ExpenseCategory(
    id: categoryId,
    name: categoryObject[JSON_CATEGORY_NAME] as String,
    color: Color(categoryObject[JSON_CATEGORY_COLOR] as int),
  );

  return Expense(
    id: id,
    category: category,
    cost: Amount.fromTotalCents(object[JSON_EXPENSE_COST] as int),
    createdAt: DateTime.parse(object[JSON_EXPENSE_CREATED_AT] as String),
    note: object[JSON_EXPENSE_NOTE] as String,
  );
}

Expense oldObjectToExpense(
  Map<String, Object> json, {
  required int id,
  required int categoryId,
  required Color color,
}) {
  return Expense(
    id: id,
    category: ExpenseCategory(
      id: categoryId,
      name: json[JSON_EXPENSE_CATEGORY] as String,
      color: color,
    ),
    cost: Amount.fromTotalCents(json[JSON_EXPENSE_COST] as int),
    createdAt: DateTime.parse(json[JSON_EXPENSE_CREATED_AT] as String),
    note: json[JSON_EXPENSE_NOTE] as String,
  );
}
