import 'dart:async';

import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/datetime.dart';

class ExpenseEditorPage extends StatefulWidget {
  final int id;

  ExpenseEditorPage({required this.id});

  @override
  _ExpenseEditorPageState createState() => _ExpenseEditorPageState(id);
}

class _ExpenseEditorPageState extends State<ExpenseEditorPage> {
  final int _id;
  late ExpenseProvider _provider;

  final _categoryController = TextEditingController();
  final _costController = TextEditingController();
  final _noteController = TextEditingController();

  var _allCategories = <ExpenseCategory>[];
  var _createdAt = DateTime.now();

  var _canSave = false;

  _ExpenseEditorPageState(this._id);

  @override
  void initState() {
    super.initState();

    _costController.addListener(() => setState(() {
          try {
            Amount.parse(_costController.text);
            _canSave = true;
          } on FormatException catch (_) {
            _canSave = false;
          }
        }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _provider = context.read<ExpenseProvider>();
      _provider.addListener(_onProviderMutation);
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _costController.dispose();
    _noteController.dispose();
    _provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _onProviderMutation() async {
    final allCategories = await _provider.getAllCategories();
    setState(() {
      _allCategories = allCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _categoryField()),
                SizedBox(width: 8),
                SizedBox(width: 100, child: _costField())
              ],
            ),
            SizedBox(height: 8),
            _noteField(),
            SizedBox(height: 16),
            _creationDateTimePicker(context),
          ],
        ),
      ),
      floatingActionButton: _saveExpenseFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomActionsBar(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(_id == Expense.UNSET_ID ? 'Add Expense' : 'Edit Expense'),
    );
  }

  Widget _categoryField() {
    return TextField(
      controller: _categoryController,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Uncategorized',
        border: OutlineInputBorder(),
        suffix: _allCategories.isNotEmpty ? _categoryDropDown() : null,
      ),
    );
  }

  Widget _categoryDropDown() {
    return DropdownButton(
      items: _allCategories
          .map((c) => DropdownMenuItem(
              value: c,
              onTap: () => _categoryController.text = c.name,
              child: Text(c.name)))
          .toList(),
    );
  }

  Widget _costField() {
    return TextField(
      controller: _costController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        labelText: 'Cost',
        hintText: '0.00',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: _noteController,
      minLines: 3,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Note',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _creationDateTimePicker(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Creation Time',
            style: textTheme.subtitle2
                ?.apply(color: colorScheme.onSurface.withOpacity(0.6))),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: _creationDatePicker(context)),
            SizedBox(width: 8),
            Expanded(child: _creationTimePicker(context))
          ],
        ),
      ],
    );
  }

  Widget _creationDatePicker(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _createdAt.dateDisplay()),
      readOnly: true,
      onTap: () => _showDatePicker(context),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today_rounded),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _creationTimePicker(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: _createdAt.time12Display()),
      readOnly: true,
      onTap: () => _showTimePicker(context),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.schedule_rounded),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(2200),
    );

    if (newDate != null) {
      setState(() {
        _createdAt = DateTime(newDate.year, newDate.month, newDate.day,
            _createdAt.hour, _createdAt.minute);
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_createdAt),
    );

    if (newTime != null) {
      setState(() {
        _createdAt = DateTime(_createdAt.year, _createdAt.month, _createdAt.day,
            newTime.hour, newTime.minute);
      });
    }
  }

  Widget _bottomActionsBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _closeEditorButton(context),
          Spacer(),
          if (_id != Expense.UNSET_ID) _deleteExpenseButton(context),
        ],
      ),
    );
  }

  Widget _closeEditorButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close_rounded),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _deleteExpenseButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.delete_outline_rounded),
        onPressed: () {
          _deleteExpense();
          Navigator.pop(context);
        });
  }

  Future<void> _deleteExpense() async {
    await _provider.delete(_id);
  }

  Widget _saveExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: _canSave
          ? () {
              _saveExpense();
              Navigator.pop(context);
            }
          : null,
      child: Icon(Icons.check),
    );
  }

  Future<void> _saveExpense() async {
    final expense = Expense(
      id: _id,
      category: ExpenseCategory(_categoryController.text),
      cost: Amount.parse(_costController.text),
      createdAt: _createdAt,
      note: _noteController.text,
    );

    if (expense.id == 0) {
      await _provider.add(expense);
    } else {
      await _provider.update(expense);
    }
  }
}
