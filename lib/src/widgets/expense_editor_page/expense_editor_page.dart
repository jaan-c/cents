import 'dart:async';

import 'package:cents/src/database/app_database.dart';
import 'package:cents/src/database/expense_repo.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';
import '../util/datetime.dart';

class ExpenseEditorPage extends StatefulWidget {
  final int id;

  ExpenseEditorPage({required this.id});

  @override
  _ExpenseEditorPageState createState() => _ExpenseEditorPageState(id);
}

class _ExpenseEditorPageState extends State<ExpenseEditorPage> {
  final int _id;
  late final Future<ExpenseRepo> _repo;
  late final StreamSubscription<List<ExpenseCategory>>
      _allCategoriesSubscription;

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

    _repo = AppDatabase.getInstance().then((db) => ExpenseRepo(db));
    _initStateAsync();

    _costController.addListener(() => setState(() {
          try {
            Amount.parse(_costController.text);
            _canSave = true;
          } on FormatException catch (_) {
            _canSave = false;
          }
        }));
  }

  Future<void> _initStateAsync() async {
    final repo = await _repo;

    _allCategoriesSubscription =
        repo.categoriesStream.listen((newAllCategories) => setState(() {
              _allCategories = newAllCategories;
            }));

    final expense = await repo.get(_id);
    if (expense != null) {
      debugPrint('Restored expense $_id');
    }

    setState(() {
      _categoryController.text = expense?.category.name ?? '';
      _costController.text = expense?.cost.toString() ?? '';
      _noteController.text = expense?.note ?? '';
      _createdAt = expense?.createdAt ?? _createdAt;
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _costController.dispose();
    _noteController.dispose();
    _allCategoriesSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.id == 0 ? _addAppBar() : _editAppBar(),
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
    );
  }

  AppBar _addAppBar() {
    return AppBar(
      title: Text('Add Expense'),
    );
  }

  AppBar _editAppBar() {
    return AppBar(
      title: Text('Edit Expense'),
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

  Widget _saveExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: _canSave ? () => _saveExpense(context) : null,
      child: Icon(Icons.check),
    );
  }

  Future<void> _saveExpense(BuildContext context) async {
    final expense = Expense(
      id: _id,
      category: ExpenseCategory(_categoryController.text),
      cost: Amount.parse(_costController.text),
      createdAt: _createdAt,
      note: _noteController.text,
    );

    final repo = await _repo;
    if (expense.id == 0) {
      await repo.add(expense);
    } else {
      await repo.update(expense);
    }

    Navigator.pop(context);
  }
}
