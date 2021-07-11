import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/category_editor_page/category_editor_page.dart';
import 'package:cents/src/ui/category_editor_page/category_editor_page_model.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListPageModel extends StateModel {
  final ExpenseProvider provider;

  var _categories = <ExpenseCategory>[];
  List<ExpenseCategory> get categories => _categories.toList();

  CategoryListPageModel({required this.provider});

  @override
  void initState() {
    super.initState();

    provider.addListener(_updateStateFromProvider);

    _updateStateFromProvider();
  }

  @override
  void dispose() {
    provider.removeListener(_updateStateFromProvider);

    super.dispose();
  }

  Future<void> _updateStateFromProvider() async {
    final categories = await provider.getEveryCategory();

    _categories = categories;
    notifyListeners();
  }

  Future<void> deleteCategoryAndOwnedExpenses(ExpenseCategory category) async {
    final expenses = await provider.getEveryExpense();
    final expensesUnderCategory = expenses.where((e) => e.category == category);

    await provider.deleteAllExpenses(expensesUnderCategory.map((e) => e.id));
    await provider.deleteAllCategories([category.id]);
  }

  Future<void> navigateToEditor({
    required BuildContext context,
    int categoryId = ExpenseCategory.UNSET_ID,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CategoryEditorPage(
          model: CategoryEditorPageModel(
            provider: context.read<ExpenseProvider>(),
            id: categoryId,
          ),
        );
      }),
    );
  }
}
