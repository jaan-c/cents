import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/widgets/expense_editor_page/expense_editor_page.dart';
import 'package:cents/src/widgets/expense_stats_page/expense_stats_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expense_list_page_scaffold.dart';

class ExpenseListPage extends StatefulWidget {
  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  late ExpenseProvider provider;
  final DateTime currentDate = DateTime.now();
  var allExpenses = <Expense>[];
  var expenseSelection = <Expense>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      provider = context.read<ExpenseProvider>();
      _onProviderMutation();
      provider.addListener(_onProviderMutation);
    });
  }

  @override
  void dispose() {
    final provider = context.read<ExpenseProvider>();
    provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _onProviderMutation() async {
    final newAllExpenses = await provider.getAllExpenses();
    setState(() {
      allExpenses = newAllExpenses;
      expenseSelection = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseListPageScaffold(
      currentDate: currentDate,
      allExpenses: allExpenses,
      expenseSelection: expenseSelection,
      onSelectExpense: _onSelectExpense,
      onDeselectExpense: _onDeselectExpense,
      onDeleteExpenses: _deleteExpenses,
      onOpenEditor: (expenseId) => _navigateToEditorPage(context, expenseId),
      onOpenStats: () => _navigateToStatsPage(context),
    );
  }

  void _onSelectExpense(Expense expense) {
    setState(() {
      expenseSelection = {...expenseSelection}..add(expense);
    });
  }

  void _onDeselectExpense(Expense expense) {
    setState(() {
      expenseSelection = {...expenseSelection}
        ..removeWhere((e) => e == expense);
    });
  }

  Future<void> _deleteExpenses(List<int> expenseIds) async {
    for (final i in expenseIds) {
      await provider.delete(i);
    }

    setState(() {
      expenseSelection = {};
    });
  }

  void _navigateToEditorPage(BuildContext context, int expenseId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseEditorPage(id: expenseId)),
    );
  }

  void _navigateToStatsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseStatsPage()),
    );
  }
}
