import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  var _categorySelection = <String>[];
  List<String> get categorySelection => _categorySelection.toList()
    ..removeWhere((c) => c == categoryController.text);

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

    provider.addListener(notifyListeners);

    categoryController.addListener(notifyListeners);
    costController.addListener(notifyListeners);
    noteController.addListener(notifyListeners);

    if (!isExpenseNew) {
      _initFieldsFromProvider();
    }

    _initCategorySelection();
  }

  Future<void> _initFieldsFromProvider() async {
    final expense = await provider.get(id);

    if (expense != null) {
      categoryController.text = expense.category.name;
      costController.text = expense.cost.toString();
      noteController.text = expense.note;
      _createdAt = expense.createdAt;

      notifyListeners();
    }
  }

  Future<void> _initCategorySelection() async {
    final categories = await provider.getAllCategories();

    _categorySelection = categories.map((c) => c.name).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    provider.removeListener(notifyListeners);

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

    final expense = Expense(
      id: id,
      category: ExpenseCategory(categoryController.text),
      cost: Amount.parse(costController.text),
      note: noteController.text,
      createdAt: createdAt,
    );

    if (isExpenseNew) {
      await provider.add(expense);
    } else {
      await provider.update(expense);
    }

    close(context);
  }

  Future<void> delete(BuildContext context) async {
    assert(!isExpenseNew);

    await provider.delete(id);

    close(context);
  }
}
