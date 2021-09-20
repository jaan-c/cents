import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';

typedef SelectCategoryCallback = void Function(ExpenseCategory);

class CategoryFilterDialog extends StatelessWidget {
  static Future<void> show({
    required BuildContext context,
    required ExpenseCategory? category,
    required List<ExpenseCategory> categories,
    required SelectCategoryCallback onSelectCategory,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => CategoryFilterDialog(
        category: category,
        categories: categories,
        onSelectCategory: onSelectCategory,
      ),
      barrierDismissible: true,
    );
  }

  final ExpenseCategory? category;
  final List<ExpenseCategory> categories;
  final SelectCategoryCallback onSelectCategory;

  CategoryFilterDialog({
    required this.category,
    required this.categories,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      /// Default from SimpleDialog docs, but remove horizontal padding.
      contentPadding: EdgeInsets.only(top: 12, bottom: 16),
      title: Text('Select Category'),
      children: [
        for (final c in categories)
          _CategoryListTile(
            category: c,
            onTap: () {
              onSelectCategory(c);
              Navigator.pop(context);
            },
            isSelected: c == category,
          ),
      ],
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback onTap;
  final bool isSelected;

  const _CategoryListTile({
    required this.category,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle_rounded,
        color: category.color,
      ),
      title: Text(
        category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      selected: isSelected,
      dense: true,
    );
  }
}
