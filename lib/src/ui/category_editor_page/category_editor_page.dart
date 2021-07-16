import 'package:cents/src/ui/widgets/countdown_prompt_dialog.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';

import 'category_editor_page_model.dart';
import 'grid_color_picker.dart';

typedef SetColorCallback = void Function(Color);

class CategoryEditorPage extends StatefulWidget {
  final CategoryEditorPageModel model;

  const CategoryEditorPage({required this.model});

  @override
  _CategoryEditorPageState createState() => _CategoryEditorPageState(model);
}

class _CategoryEditorPageState
    extends StateWithModel<CategoryEditorPage, CategoryEditorPageModel> {
  static final _colors = [
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.brown,
  ].map((e) => e[300]!).toList();

  @override
  final CategoryEditorPageModel model;

  _CategoryEditorPageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(
        context: context,
        isCategoryNew: model.isCategoryNew,
        onDelete: () => model.deleteCategoryAndOwnedExpenses(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              _nameField(model.nameController),
              SizedBox(height: 16),
              _colorField(
                context: context,
                color: model.color,
                setColor: model.setColor,
              ),
              SizedBox(height: 16),
              _pageActions(
                onClose: () => model.popPage(context),
                areFieldsValid: model.areFieldsValid,
                onSave: () => model.save(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar({
    required BuildContext context,
    required bool isCategoryNew,
    required VoidCallback onDelete,
  }) {
    return AppBar(
      title: Text(isCategoryNew ? 'Add Category' : 'Edit Category'),
      actions: [
        if (!isCategoryNew)
          IconButton(
            icon: Icon(Icons.delete_rounded),
            onPressed: () => _showDeleteDialog(context, onDelete),
          ),
      ],
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    VoidCallback onDelete,
  ) async {
    final dangerColor = Theme.of(context).colorScheme.error;

    return CountdownPromptDialog.show(
      context: context,
      title: 'Delete category?',
      message: 'Delete this category and all associated expenses?',
      positiveButtonText: 'DELETE',
      positiveButtonColor: dangerColor,
      onPositivePressed: onDelete,
      barrierDismissable: true,
    );
  }

  Widget _nameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Category',
        hintText: 'Name',
        border: OutlineInputBorder(),
      ),
      autofocus: true,
    );
  }

  Widget _colorField({
    required BuildContext context,
    required Color color,
    required SetColorCallback setColor,
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
        Text('Color', style: subheaderStyle),
        SizedBox(height: 8),
        GridColorPicker(
          colors: _colors,
          selectedColor: color,
          onSelectColor: setColor,
        ),
      ],
    );
  }

  Widget _pageActions({
    required VoidCallback onClose,
    required bool areFieldsValid,
    required VoidCallback onSave,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onClose, child: Text('CANCEL')),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: areFieldsValid ? onSave : null,
          child: Text('SAVE'),
        ),
      ],
    );
  }
}
