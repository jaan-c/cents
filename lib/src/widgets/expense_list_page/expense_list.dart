import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_page_scaffold.dart';
import 'expense_list_tile.dart';
import 'edit_expense_callback.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Set<Expense> expenseSelection;
  final EditExpenseCallback onEditExpense;
  final SelectExpenseCallback onSelectExpense;
  final DeselectExpenseCallback onDeselectExpense;

  bool get isSelectionMode => expenseSelection.isNotEmpty;

  ExpenseList(
      {required this.expenses,
      required this.expenseSelection,
      required this.onEditExpense,
      required this.onSelectExpense,
      required this.onDeselectExpense});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, ix) {
        final e = expenses[ix];

        if (!isSelectionMode) {
          return ExpenseListTile(
            expense: e,
            onTap: () => onEditExpense(e.id),
            onLongPress: () => onSelectExpense(e),
            isSelected: false,
          );
        } else {
          final isSelected = expenseSelection.contains(e);

          return ExpenseListTile(
            expense: e,
            onTap: !isSelected
                ? () => onSelectExpense(e)
                : () => onDeselectExpense(e),
            isSelected: isSelected,
          );
        }
      },
      separatorBuilder: (_, __) => Divider(height: 1),
      itemCount: expenses.length,
    );
  }
}
