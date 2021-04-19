import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/widgets/expense_editor_page/expense_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expense_list.dart';

class ExpenseListPage extends StatefulWidget {
  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  late ExpenseProvider _provider;
  var _allExpenses = <Expense>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _provider = context.read<ExpenseProvider>();
      _onProviderMutation();
      _provider.addListener(_onProviderMutation);
    });
  }

  @override
  void dispose() {
    final provider = context.read<ExpenseProvider>();
    provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _onProviderMutation() async {
    final allExpenses = await _provider.getAllExpenses();
    setState(() {
      _allExpenses = allExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses')),
      body: ExpenseList(expenses: _allExpenses),
      floatingActionButton: _addExpenseFab(context),
    );
  }

  Widget _addExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToEditor(context, 0),
      child: Icon(Icons.add),
    );
  }

  void _navigateToEditor(BuildContext context, int expenseId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseEditorPage(id: expenseId)),
    );
  }
}
