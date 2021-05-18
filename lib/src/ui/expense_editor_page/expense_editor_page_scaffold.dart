import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/ext_date.dart';
import 'package:flutter/material.dart';

typedef SaveExpenseCallback = void Function(Expense);
typedef DeleteExpenseCallback = void Function(int expenseId);
typedef CloseCallback = void Function();

class ExpenseEditorPageScaffold extends StatefulWidget {
  final int id;
  final String category;
  final String cost;
  final String note;
  final DateTime createdAt;
  final List<String> categorySelection;
  final SaveExpenseCallback onSaveExpense;
  final DeleteExpenseCallback onDeleteExpense;
  final CloseCallback onClose;

  ExpenseEditorPageScaffold(
      {required this.id,
      required this.category,
      required this.cost,
      required this.note,
      required this.createdAt,
      required this.categorySelection,
      required this.onSaveExpense,
      required this.onDeleteExpense,
      required this.onClose});

  @override
  _ExpenseEditorPageScaffoldState createState() =>
      _ExpenseEditorPageScaffoldState(
          id: id,
          category: category,
          cost: cost,
          note: note,
          createdAt: createdAt,
          categorySelection: categorySelection,
          onSaveExpense: onSaveExpense,
          onDeleteExpense: onDeleteExpense,
          onClose: onClose);
}

class _ExpenseEditorPageScaffoldState extends State<ExpenseEditorPageScaffold> {
  int id;
  final TextEditingController categoryController;
  final TextEditingController costController;
  final TextEditingController noteController;
  DateTime createdAt;
  List<String> categorySelection;

  SaveExpenseCallback onSaveExpense;
  DeleteExpenseCallback onDeleteExpense;
  CloseCallback onClose;

  bool get canSave {
    try {
      Amount.parse(costController.text);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  _ExpenseEditorPageScaffoldState(
      {required this.id,
      required String category,
      required String cost,
      required String note,
      required this.createdAt,
      required this.categorySelection,
      required this.onSaveExpense,
      required this.onDeleteExpense,
      required this.onClose})
      : categoryController = TextEditingController(text: category),
        costController = TextEditingController(text: cost),
        noteController = TextEditingController(text: note);

  @override
  void initState() {
    super.initState();

    costController.addListener(() => setState(() {}));
    categoryController.addListener(_filterCategorySelection);

    _filterCategorySelection();
  }

  @override
  void didUpdateWidget(covariant ExpenseEditorPageScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      id = widget.id;
      categoryController.text = widget.category;
      costController.text = widget.cost;
      noteController.text = widget.note;
      createdAt = widget.createdAt;
      categorySelection = widget.categorySelection;
      onSaveExpense = widget.onSaveExpense;
      onDeleteExpense = widget.onDeleteExpense;
      onClose = widget.onClose;
    });

    _filterCategorySelection();
  }

  @override
  void dispose() {
    categoryController.dispose();
    costController.dispose();
    noteController.dispose();

    super.dispose();
  }

  void _filterCategorySelection() {
    final newCategorySelection = widget.categorySelection
        .where((c) => c != categoryController.text)
        .toList();
    setState(() {
      categorySelection = newCategorySelection;
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
      title: Text(id == Expense.UNSET_ID ? 'Add Expense' : 'Edit Expense'),
    );
  }

  Widget _categoryField() {
    return TextField(
      controller: categoryController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Uncategorized',
        border: OutlineInputBorder(),
        suffixIcon:
            categorySelection.isNotEmpty ? _categoryPickerButton() : null,
      ),
    );
  }

  Widget _categoryPickerButton() {
    return PopupMenuButton<String>(
      onSelected: (category) => setState(() {
        categoryController.text = category;
      }),
      icon: Icon(Icons.expand_more_rounded),
      itemBuilder: (_) {
        return categorySelection
            .map((c) => PopupMenuItem(value: c, child: Text(c)))
            .toList();
      },
    );
  }

  Widget _costField() {
    return TextField(
      controller: costController,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Cost',
        hintText: '0.00',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: noteController,
      textCapitalization: TextCapitalization.sentences,
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
      controller: TextEditingController(text: createdAt.dateDisplay()),
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
      controller: TextEditingController(text: createdAt.time12Display()),
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
      initialDate: createdAt,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(2200),
    );

    if (newDate != null) {
      setState(() {
        createdAt = DateTime(newDate.year, newDate.month, newDate.day,
            createdAt.hour, createdAt.minute);
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(createdAt),
    );

    if (newTime != null) {
      setState(() {
        createdAt = DateTime(createdAt.year, createdAt.month, createdAt.day,
            newTime.hour, newTime.minute);
      });
    }
  }

  Widget _bottomActionsBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _closeEditorButton(context),
            Spacer(),
            if (id != Expense.UNSET_ID) _deleteExpenseButton(context),
          ],
        ),
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
          onDeleteExpense(id);
          Navigator.pop(context);
        });
  }

  Widget _saveExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: canSave
          ? () {
              onSaveExpense(expenseFromState());
              Navigator.pop(context);
            }
          : null,
      child: Icon(Icons.check),
    );
  }

  Expense expenseFromState() {
    return Expense(
        id: id,
        category: ExpenseCategory(categoryController.text),
        cost: Amount.parse(costController.text),
        createdAt: createdAt,
        note: noteController.text);
  }
}
