import 'package:cents/src/domain/expense.dart';

import 'expense_provider.dart';
import 'column_converter.dart';

extension ExpenseToRow on Expense {
  Map<String, Object> toRow() {
    return {
      if (id != Expense.UNSET_ID) COLUMN_ID: id,
      COLUMN_CATEGORY: category.toColumn(),
      COLUMN_COST: cost.toColumn(),
      COLUMN_CREATED_AT: createdAt.toColumn(),
      COLUMN_NOTE: note,
    };
  }
}

extension ExpenseFromRow on Map<String, Object> {
  Expense fromRow() {
    return Expense(
        id: (this[COLUMN_ID] ?? Expense.UNSET_ID) as int,
        category: (this[COLUMN_CATEGORY]! as String).toCategory(),
        cost: (this[COLUMN_COST]! as int).toCost(),
        createdAt: (this[COLUMN_CREATED_AT]! as String).toDateTime(),
        note: this[COLUMN_NOTE]! as String);
  }
}
