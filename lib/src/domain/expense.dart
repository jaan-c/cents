import 'package:quiver/core.dart';

import 'amount.dart';
import 'expense_category.dart';

class Expense {
  static const UNSET_ID = 0;

  final int id;
  final ExpenseCategory category;
  final Amount cost;
  final DateTime createdAt;
  final String note;

  Expense(
      {this.id = UNSET_ID,
      required this.category,
      required this.cost,
      required this.createdAt,
      this.note = ''});

  Expense copyWith(
      {int? id = 0,
      ExpenseCategory? category,
      Amount? cost,
      DateTime? createdAt,
      String? note}) {
    return Expense(
        id: id ?? this.id,
        category: category ?? this.category,
        cost: cost ?? this.cost,
        createdAt: createdAt ?? this.createdAt,
        note: note ?? this.note);
  }

  @override
  bool operator ==(dynamic other) {
    return other is Expense && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hashObjects([id, category, cost, createdAt, note]);
}
