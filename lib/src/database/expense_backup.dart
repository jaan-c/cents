import 'dart:convert';

import 'package:cents/src/domain/expense.dart';

import 'expense_provider.dart';
import 'row_converter.dart';

extension ExpenseBackup on ExpenseProvider {
  Future<String> exportAsJson() async {
    final expenses = await getAllExpenses();

    return expenses.toJsonString();
  }

  Future<void> importFromJson(String json) async {
    final expenses = json.toExpenses();

    await addAll(expenses);
  }
}

extension _JsonEncoder on List<Expense> {
  String toJsonString() {
    final maps = map((e) => e.toRow()..remove('id')).toList();

    return jsonEncode(maps);
  }
}

extension _JsonDecoder on String {
  List<Expense> toExpenses() {
    late final List<Map<String, Object>> maps;
    try {
      maps = (jsonDecode(this) as List)
          .map((m) => (m as Map<String, dynamic>).cast<String, Object>())
          .toList();
    } on TypeError catch (_) {
      throw FormatException('Unexpected JSON schema.');
    }

    return maps.map((m) => m.fromRow()).toList();
  }
}
