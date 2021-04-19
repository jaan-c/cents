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
      appBar: _appBar(context),
      body: ExpenseList(
        expenses: _allExpenses,
        onEditExpense: (expenseId) => _navigateToEditor(context, expenseId),
      ),
      floatingActionButton: _addExpenseFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(),
    );
  }

  AppBar _appBar(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      title: Text(
        'Expenses',
        style: textTheme.headline6?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _addExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToEditor(context, 0),
      child: Icon(Icons.add),
    );
  }

  Widget _bottomBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Spacer(), _overflowMenuButton()],
      ),
    );
  }

  Widget _overflowMenuButton() {
    return PopupMenuButton(
      itemBuilder: (_) {
        return ['Settings', 'About']
            .map((x) => PopupMenuItem(value: x, child: Text(x)))
            .toList();
      },
    );
  }

  void _navigateToEditor(BuildContext context, int expenseId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseEditorPage(id: expenseId)),
    );
  }
}
