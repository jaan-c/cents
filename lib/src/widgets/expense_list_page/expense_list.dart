import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_tile.dart';
import 'edit_expense_callback.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final EditExpenseCallback onEditExpense;

  ExpenseList({required this.expenses, required this.onEditExpense});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, ix) => ExpenseListTile(
        expense: expenses[ix],
        onEditExpense: onEditExpense,
      ),
      separatorBuilder: (_, __) => Divider(height: 1),
      itemCount: expenses.length,
    );
  }
}
