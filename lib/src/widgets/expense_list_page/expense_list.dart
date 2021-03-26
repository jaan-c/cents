import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_tile.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, ix) => ExpenseListTile(expense: expenses[ix]),
      separatorBuilder: (_, __) => Divider(),
      itemCount: expenses.length,
    );
  }
}
