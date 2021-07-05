import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';

import 'category_list_page_model.dart';
import 'category_list_tile.dart';

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
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('Categories'),
    );
  }

  Widget _body() {
    final categories = model.categories;

    return ListView.separated(
      itemBuilder: (_, ix) {
        final category = categories[ix];

        return CategoryListTile(
          category: category,
          onDelete: () => _showDeleteDialog(context, category),
        );
      },
      separatorBuilder: (_, __) => Divider(height: 1),
      itemCount: categories.length,
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ExpenseCategory category,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => _deleteDialog(context: context, category: category),
      barrierDismissible: true,
    );
  }

  Widget _deleteDialog({
    required BuildContext context,
    required ExpenseCategory category,
  }) {
    final dangerColor = Theme.of(context).colorScheme.error;

    return AlertDialog(
      title: Text('Delete category?'),
      content: Text(
        'This will delete ${category.name} category and all ${category.name} expense.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () async {
            await model.deleteCategoryAndOwnedExpenses(category);
            Navigator.pop(context);
          },
          child: Text('DELETE', style: TextStyle(color: dangerColor)),
        ),
      ],
    );
  }
}
