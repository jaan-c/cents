import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:cents/src/domain/ext_date_time.dart';
import 'package:flutter/material.dart';

import 'expense_editor_page_model.dart';

typedef _SetCreationDateCallback = void Function(DateTime);
typedef _SetCreationTimeCallback = void Function(TimeOfDay);

class ExpenseEditorPage extends StatefulWidget {
  final ExpenseEditorPageModel model;

  ExpenseEditorPage({required this.model});

  @override
  _ExpenseEditorPageState createState() => _ExpenseEditorPageState(model);
}

class _ExpenseEditorPageState
    extends StateWithModel<ExpenseEditorPage, ExpenseEditorPageModel> {
  @override
  final ExpenseEditorPageModel model;

  _ExpenseEditorPageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(
        isExpenseNew: model.isExpenseNew,
        onDelete: () => model.delete(context),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _primaryFields(
                categoryController: model.categoryController,
                costController: model.costController,
                categorySelection: model.categorySelection,
              ),
              SizedBox(height: 8),
              _secondaryFields(
                noteController: model.noteController,
                createdAt: model.createdAt,
                setCreationDate: model.setCreationDate,
                setCreationTime: model.setCreationTime,
              ),
              SizedBox(height: 16),
              _sheetActions(
                onSave: model.areFieldsValid ? () => model.save(context) : null,
                onClose: () => model.close(context),
                onDelete:
                    model.isExpenseNew ? null : () => model.delete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar({
    required bool isExpenseNew,
    required VoidCallback onDelete,
  }) {
    return AppBar(
      title: Text(isExpenseNew ? 'Add Expense' : 'Edit Expense'),
      actions: [
        if (!isExpenseNew)
          IconButton(
            icon: Icon(Icons.delete_rounded),
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _primaryFields({
    required TextEditingController categoryController,
    required TextEditingController costController,
    required List<String> categorySelection,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _categoryField(
            controller: categoryController,
            categorySelection: categorySelection,
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: _costField(controller: costController),
        ),
      ],
    );
  }

  Widget _categoryField({
    required TextEditingController controller,
    required List<String> categorySelection,
  }) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Uncategorized',
        border: OutlineInputBorder(),
        suffixIcon: categorySelection.isNotEmpty
            ? _categorySelectionDropdown(
                controller: controller,
                categorySelection: categorySelection,
              )
            : null,
      ),
    );
  }

  Widget _categorySelectionDropdown({
    required TextEditingController controller,
    required List<String> categorySelection,
  }) {
    return PopupMenuButton<String>(
      onSelected: (category) => controller.text = category,
      icon: Icon(Icons.expand_more_rounded),
      itemBuilder: (_) => [
        for (final category in categorySelection)
          PopupMenuItem(
            value: category,
            child: Text(category),
          ),
      ],
    );
  }

  Widget _costField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Cost',
        hintText: '0.00',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _secondaryFields({
    required TextEditingController noteController,
    required DateTime createdAt,
    required _SetCreationDateCallback setCreationDate,
    required _SetCreationTimeCallback setCreationTime,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _noteField(controller: noteController),
        SizedBox(height: 8),
        _creationDateTimePicker(
          createdAt: createdAt,
          setCreationDate: setCreationDate,
          setCreationTime: setCreationTime,
        ),
      ],
    );
  }

  Widget _noteField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      minLines: 3,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Note',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _creationDateTimePicker({
    required DateTime createdAt,
    required _SetCreationDateCallback setCreationDate,
    required _SetCreationTimeCallback setCreationTime,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final subheaderStyle = textTheme.subtitle2?.apply(
        color: theme.brightness == Brightness.light
            ? Colors.black54
            : Colors.white54);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Creation Time', style: subheaderStyle),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: _creationDatePicker(
                createdAt: createdAt,
                setCreationDate: setCreationDate,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _creationTimePicker(
                creationTime: TimeOfDay.fromDateTime(createdAt),
                setCreationTime: setCreationTime,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _creationDatePicker({
    required DateTime createdAt,
    required _SetCreationDateCallback setCreationDate,
  }) {
    return TextField(
      controller: TextEditingController(text: createdAt.dateDisplay()),
      onTap: () => _showDatePicker(
          creationDate: createdAt, setCreationDate: setCreationDate),
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_today_rounded),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _showDatePicker({
    required DateTime creationDate,
    required _SetCreationDateCallback setCreationDate,
  }) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: creationDate,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(2200),
    );

    if (newDate != null) {
      setCreationDate(newDate);
    }
  }

  Widget _creationTimePicker({
    required TimeOfDay creationTime,
    required _SetCreationTimeCallback setCreationTime,
  }) {
    return TextField(
      controller: TextEditingController(text: creationTime.display12()),
      onTap: () => _showTimePicker(
          creationTime: creationTime, setCreationTime: setCreationTime),
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.schedule_rounded),
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _showTimePicker({
    required TimeOfDay creationTime,
    required _SetCreationTimeCallback setCreationTime,
  }) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: creationTime,
    );

    if (newTime != null) {
      setCreationTime(newTime);
    }
  }

  Widget _sheetActions({
    required VoidCallback? onSave,
    required VoidCallback onClose,
    required VoidCallback? onDelete,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onClose, child: Text('CANCEL')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: onSave, child: Text('SAVE')),
      ],
    );
  }
}
