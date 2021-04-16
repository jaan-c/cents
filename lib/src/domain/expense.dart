import 'package:quiver/core.dart';

import 'amount.dart';
import 'expense_category.dart';

class Expense {
  static const UNSET_ID = 0;

  final int id;
  final Amount cost;
  final ExpenseCategory category;
  final DateTime createdAt;
  final String note;

  Expense(
      {this.id = UNSET_ID,
      required this.cost,
      required this.category,
      required this.createdAt,
      this.note = ''});

  Expense copyWith(
      {int? id = 0,
      Amount? cost,
      ExpenseCategory? category,
      DateTime? createdAt,
      String? note}) {
    return Expense(
        id: id ?? this.id,
        cost: cost ?? this.cost,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
        note: note ?? this.note);
  }

  @override
  bool operator ==(dynamic other) {
    return other is Expense && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hashObjects([id, cost, category, createdAt, note]);
}
