import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/countdown_prompt_dialog.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';

import 'category_list_page_model.dart';
import 'category_list_tile.dart';

typedef _AddCategoryCallback = void Function();
typedef _EditCategoryCallback = void Function(ExpenseCategory);
typedef _DeleteCategoryCallback = void Function(ExpenseCategory);

class CategoryListPage extends StatefulWidget {
  final CategoryListPageModel model;

  CategoryListPage({required this.model});

  @override
  _CategoryListPageState createState() => _CategoryListPageState(model);
}

class _CategoryListPageState
    extends StateWithModel<CategoryListPage, CategoryListPageModel> {
  @override
  final CategoryListPageModel model;

  _CategoryListPageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(
        categories: model.categories,
        onEditCategory: (category) => model.navigateToEditor(
          context: context,
          categoryId: category.id,
        ),
        onDeleteCategory: (category) => _showDeleteDialog(
          context,
          category.name,
          () => model.deleteCategoryAndOwnedExpenses(category),
        ),
      ),
      floatingActionButton: _addCategoryFab(
        onAddCategory: () => model.navigateToEditor(context: context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('Categories'),
    );
  }

  Widget _body({
    required List<ExpenseCategory> categories,
    required _EditCategoryCallback onEditCategory,
    required _DeleteCategoryCallback onDeleteCategory,
  }) {
    return ListView.separated(
      itemBuilder: (_, ix) {
        final category = categories[ix];

        return CategoryListTile(
          category: category,
          onTap: () => onEditCategory(category),
          onDelete: () => onDeleteCategory(category),
        );
      },
      separatorBuilder: (_, __) => Divider(height: 1),
      itemCount: categories.length,
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String categoryName,
    VoidCallback onDelete,
  ) async {
    final dangerColor = Theme.of(context).colorScheme.error;

    return CountdownPromptDialog.show(
      context: context,
      title: 'Delete category?',
      message: 'Delete $categoryName category and all associated expenses?',
      positiveButtonText: 'DELETE',
      positiveButtonColor: dangerColor,
      onPositivePressed: onDelete,
      barrierDismissable: true,
    );
  }

  Widget _addCategoryFab({required _AddCategoryCallback onAddCategory}) {
    return FloatingActionButton.extended(
      onPressed: onAddCategory,
      icon: Icon(Icons.add_rounded),
      label: Text('Add Category'),
    );
  }
}
