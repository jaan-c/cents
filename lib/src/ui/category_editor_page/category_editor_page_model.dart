import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/widgets.dart';
import 'package:cents/src/domain/ext_string.dart';

class CategoryEditorPageModel extends StateModel {
  final ExpenseProvider provider;
  final int id;

  final nameController = TextEditingController();

  var _color = ExpenseCategory.DEFAULT_COLOR;
  Color get color => _color;

  bool get isCategoryNew => id == ExpenseCategory.UNSET_ID;
  bool get canDelete => !isCategoryNew;
  bool get areFieldsValid => nameController.text.isNotBlank;

  CategoryEditorPageModel({
    required this.provider,
    this.id = ExpenseCategory.UNSET_ID,
  });

  @override
  void initState() {
    super.initState();

    _initFields();
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  Future<void> _initFields() async {
    if (isCategoryNew) {
      return;
    }

    final category = (await provider.getCategory(id)) ??
        (throw StateError('Editing a non-existent category with id $id'));

    nameController.text = category.name;
    _color = category.color;
    notifyListeners();
  }

  void setColor(Color newColor) {
    _color = newColor;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (!areFieldsValid) {
      throw StateError('Attempting to save invalid fields.');
    }

    final category = ExpenseCategory(
      id: id,
      name: nameController.text,
      color: color,
    );
    if (isCategoryNew) {
      await provider.addAllCategories([category]);
    } else {
      await provider.updateAllCategories([category]);
    }

    popPage(context);
  }

  Future<void> deleteCategoryAndOwnedExpenses(BuildContext context) async {
    if (!canDelete) {
      throw StateError('Attempting to delete unset id.');
    }

    final category = (await provider.getCategory(id))!;
    final expenses = await provider.getEveryExpense();
    final expensesUnderCategory = expenses.where((e) => e.category == category);

    await provider.deleteAllExpenses(expensesUnderCategory.map((e) => e.id));
    await provider.deleteAllCategories([category.id]);

    popPage(context);
  }

  void popPage(BuildContext context) {
    Navigator.pop(context);
  }
}
