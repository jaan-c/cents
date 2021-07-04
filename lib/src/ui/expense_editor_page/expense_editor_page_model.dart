import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'utils.dart';

class ExpenseEditorPageModel extends StateModel {
  final ExpenseProvider provider;

  final int id;
  final categoryController = TextEditingController();
  final costController = TextEditingController();
  final noteController = TextEditingController();

  var _createdAt = DateTime.now();
  DateTime get createdAt => _createdAt;
  DateTime get creationDate =>
      DateTime(createdAt.year, createdAt.month, createdAt.day);
  TimeOfDay get creationTime =>
      TimeOfDay(hour: createdAt.hour, minute: createdAt.minute);

  var _categorySelection = <String, ExpenseCategory>{};
  Map<String, ExpenseCategory> get categorySelection =>
      Map<String, ExpenseCategory>.from(_categorySelection);
  Map<String, ExpenseCategory> get categorySelectionFiltered =>
      Map<String, ExpenseCategory>.from(_categorySelection)
        ..remove(categoryController.text);

  bool get isExpenseNew => id == Expense.UNSET_ID;

  bool get areFieldsValid {
    try {
      Amount.parse(costController.text);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  ExpenseEditorPageModel({
    required this.provider,
    this.id = Expense.UNSET_ID,
  });

  @override
  void initState() {
    super.initState();

    categoryController.addListener(notifyListeners);
    costController.addListener(notifyListeners);
    noteController.addListener(notifyListeners);

    if (!isExpenseNew) {
      _initFieldsFromProvider();
    }
    _initCategorySelection();
  }

  Future<void> _initFieldsFromProvider() async {
    final expense = await provider.getExpense(id);

    if (expense != null) {
      categoryController.text = expense.category.name;
      costController.text = expense.cost.toString();
      noteController.text = expense.note;
      _createdAt = expense.createdAt;

      notifyListeners();
    }
  }

  Future<void> _initCategorySelection() async {
    final categories = await provider.getEveryCategory();

    _categorySelection =
        Map.fromEntries(categories.map((c) => MapEntry(c.name, c)));

    notifyListeners();
  }

  @override
  void dispose() {
    categoryController.dispose();
    costController.dispose();
    noteController.dispose();

    super.dispose();
  }

  void setCreationDate(DateTime newCreationDate) {
    assert(createdAt.timeZoneOffset == newCreationDate.timeZoneOffset);

    final newCreatedAt = DateTime(
      newCreationDate.year,
      newCreationDate.month,
      newCreationDate.day,
      createdAt.hour,
      createdAt.minute,
    );

    _createdAt = newCreatedAt;
    notifyListeners();
  }

  void setCreationTime(TimeOfDay newCreationTime) {
    final newCreatedAt = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
      newCreationTime.hour,
      newCreationTime.minute,
    );

    _createdAt = newCreatedAt;
    notifyListeners();
  }

  void close(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> save(BuildContext context) async {
    assert(areFieldsValid);

    final brightness = Theme.of(context).brightness;
    final categoryName = categoryController.text;
    var category = categorySelection[categoryName] ??
        ExpenseCategory(
          name: categoryName,
          color: textToColor(brightness, categoryName),
        );

    if (category.id == ExpenseCategory.UNSET_ID) {
      debugPrint('adding new category: $category');
      await provider.addAllCategories([category]);
      category = (await provider.getCategoryByName(categoryName))!;
    }

    final expense = Expense(
      id: id,
      category: category,
      cost: Amount.parse(costController.text),
      note: noteController.text,
      createdAt: createdAt,
    );

    if (isExpenseNew) {
      await provider.addAllExpenses([expense]);
    } else {
      await provider.updateAllExpenses([expense]);
    }

    close(context);
  }

  Future<void> delete(BuildContext context) async {
    assert(!isExpenseNew);

    await provider.deleteAllExpenses([id]);

    close(context);
  }
}
