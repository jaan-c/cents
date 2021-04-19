import 'dart:async';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expense_editor_page_scaffold.dart';

class ExpenseEditorPage extends StatefulWidget {
  final int id;

  ExpenseEditorPage({required this.id});

  @override
  _ExpenseEditorPageState createState() => _ExpenseEditorPageState(id);
}

class _ExpenseEditorPageState extends State<ExpenseEditorPage> {
  late ExpenseProvider provider;

  final int id;
  String category = '';
  String cost = '';
  String note = '';
  DateTime createdAt = DateTime.now();
  List<String> categorySelection = [];

  _ExpenseEditorPageState(this.id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      provider = context.read<ExpenseProvider>();
      _initializeFields();
      provider.addListener(_onProviderMutation);
    });
  }

  @override
  void dispose() {
    provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _initializeFields() async {
    final expense = await provider.get(id);
    if (expense != null) {
      setState(() {
        category = expense.category.name;
        cost = expense.cost.toString();
        note = expense.note;
        createdAt = expense.createdAt;
      });
    }

    await _onProviderMutation();
  }

  Future<void> _onProviderMutation() async {
    final newCategorySelection = await provider.getAllCategories();
    setState(() {
      categorySelection = newCategorySelection.map((c) => c.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseEditorPageScaffold(
      id: id,
      category: category,
      cost: cost,
      note: note,
      createdAt: createdAt,
      categorySelection: categorySelection,
      onSaveExpense: onSaveExpense,
      onDeleteExpense: onDeleteExpense,
      onClose: () => Navigator.pop(context),
    );
  }

  Future<void> onSaveExpense(Expense expense) async {
    if (expense.id == Expense.UNSET_ID) {
      await provider.add(expense);
    } else {
      await provider.update(expense);
    }
  }

  Future<void> onDeleteExpense(int expenseId) async {
    await provider.delete(expenseId);
  }
}
