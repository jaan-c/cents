import 'dart:convert';

import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';

import 'database_backup_converter.dart';
import 'expense_provider.dart';

extension ExpenseBackup on ExpenseProvider {
  Future<void> importFromJson(String json) async {
    late final List<Expense> expenses;
    try {
      expenses = _decodeJsonBackup(json);
    } on FormatException {
      expenses = _decodeOldJsonBackup(json);
    }

    await addAllCategories(expenses.map((e) => e.category).toSet());

    final existingCategories = await getEveryCategory();
    final nameToExistingCategories =
        Map.fromEntries(existingCategories.map((c) => MapEntry(c.name, c)));
    final overridenExpenses = expenses.map((e) =>
        e.copyWith(category: nameToExistingCategories[e.category.name]!));

    await addAllExpenses(overridenExpenses);
  }

  Future<String> exportAsJson() async {
    final expenses = await getEveryExpense();

    return _encodeJsonBackup(expenses);
  }
}

List<Expense> _decodeJsonBackup(String json) {
  try {
    final objects = jsonDecode(json) as List<Map<String, Object>>;

    return objects
        .map((o) => objectToExpense(
              o,
              id: Expense.UNSET_ID,
              categoryId: ExpenseCategory.UNSET_ID,
            ))
        .toList();
  } on TypeError catch (e) {
    throw FormatException('Casting failed: $e');
  }
}

List<Expense> _decodeOldJsonBackup(String json) {
  try {
    final objects = jsonDecode(json) as List<Map<String, Object>>;

    return objects
        .map((o) => oldObjectToExpense(
              o,
              id: Expense.UNSET_ID,
              categoryId: ExpenseCategory.UNSET_ID,
              color: ExpenseCategory.DEFAULT_COLOR,
            ))
        .toList();
  } on TypeError catch (e) {
    throw FormatException('Casting failed: $e');
  }
}

String _encodeJsonBackup(List<Expense> expenses) {
  final objects = expenses.map((e) => expenseToObject(e)).toList();
  return jsonEncode(objects);
}
