import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';

class ExpenseListPage extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expenses")),
      body: ExpenseList(expenses: expenses),
    );
  }
}
