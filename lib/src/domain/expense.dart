import 'package:quiver/core.dart';

import 'amount.dart';
import 'expense_category.dart';

class Expense {
  final int id;
  final Amount cost;
  final ExpenseCategory category;
  final String note;

  Expense(
      {this.id = 0,
      this.cost = const Amount(),
      this.category = const ExpenseCategory.uncategorized(),
      this.note = ""});

  Expense copyWith(
      {int? id = 0, Amount? cost, ExpenseCategory? category, String? note}) {
    return Expense(
        id: id ?? this.id,
        cost: cost ?? this.cost,
        category: category ?? this.category,
        note: note ?? this.note);
  }

  @override
  bool operator ==(dynamic other) {
    return other is Expense && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hash4(id, cost, category, note);
}
