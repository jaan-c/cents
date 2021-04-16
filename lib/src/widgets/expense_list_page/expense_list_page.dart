import 'dart:async';

import 'package:cents/src/database/database_opener.dart';
import 'package:cents/src/database/expense_repo.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/widgets/expense_editor_page/expense_editor_page.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';

class ExpenseListPage extends StatefulWidget {
  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  late final Future<ExpenseRepo> _repo;
  late final StreamSubscription<List<Expense>> _allExpensesSubscription;

  var _allExpenses = <Expense>[];

  @override
  void initState() {
    super.initState();

    _repo = AppDatabase.getInstance().then((db) => ExpenseRepo(db));
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    final repo = await _repo;

    _allExpensesSubscription =
        repo.expensesStream.listen((newAllExpenses) => setState(() {
              _allExpenses = newAllExpenses;
            }));
  }

  @override
  void dispose() {
    _allExpensesSubscription.cancel();

    super.dispose();
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
