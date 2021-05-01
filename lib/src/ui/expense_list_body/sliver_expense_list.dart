import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_tile.dart';

typedef ToggleExpenseCallback = void Function(Expense);
typedef EditExpenseCallback = void Function(int expenseId);

class SliverExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Set<Expense> expenseSelection;
  final ToggleExpenseCallback onToggleExpense;
  final EditExpenseCallback onEditExpense;

  SliverExpenseList({
    required this.expenses,
    required this.expenseSelection,
    required this.onToggleExpense,
    required this.onEditExpense,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, ix) => _expenseListTile(
          expense: expenses[ix],
          expenseSelection: expenseSelection,
          onToggleExpense: onToggleExpense,
          onEditExpense: onEditExpense,
        ),
        childCount: expenses.length,
      ),
    );
  }

  Widget _expenseListTile({
    required Expense expense,
    required Set<Expense> expenseSelection,
    required ToggleExpenseCallback onToggleExpense,
    required EditExpenseCallback onEditExpense,
  }) {
    if (expenseSelection.isEmpty) {
      return ExpenseListTile(
        expense: expense,
        onTap: () => onEditExpense(expense.id),
        onLongPress: () => onToggleExpense(expense),
        isSelected: false,
      );
    } else {
      return ExpenseListTile(
        expense: expense,
        onTap: () => onToggleExpense(expense),
        isSelected: expenseSelection.contains(expense),
      );
    }
  }
}
