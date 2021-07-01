import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_tile.dart';

typedef ToggleExpenseCallback = void Function(Expense);
typedef EditExpenseCallback = void Function(int expenseId);

class SliverExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Set<Expense> selectedExpenses;
  final ToggleExpenseCallback onToggleSelect;
  final EditExpenseCallback onEditExpense;

  SliverExpenseList({
    required this.expenses,
    required this.selectedExpenses,
    required this.onToggleSelect,
    required this.onEditExpense,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, ix) {
          final expense = expenses[ix];

          return _expenseListTile(
            expense: expense,
            selectedExpenses: selectedExpenses,
            onToggleSelect: onToggleSelect,
            onEditExpense: onEditExpense,
            hasDivider: expense != expenses.last,
          );
        },
        childCount: expenses.length,
      ),
    );
  }

  Widget _expenseListTile({
    required Expense expense,
    required Set<Expense> selectedExpenses,
    required ToggleExpenseCallback onToggleSelect,
    required EditExpenseCallback onEditExpense,
    required bool hasDivider,
  }) {
    late final Widget tile;
    if (selectedExpenses.isEmpty) {
      tile = ExpenseListTile(
        expense: expense,
        onTap: () => onEditExpense(expense.id),
        onLongPress: () => onToggleSelect(expense),
        isSelected: false,
      );
    } else {
      tile = ExpenseListTile(
        expense: expense,
        onTap: () => onToggleSelect(expense),
        isSelected: selectedExpenses.contains(expense),
      );
    }

    if (!hasDivider) {
      return tile;
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tile,
          Divider(height: 1),
        ],
      );
    }
  }
}
