import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';

class CategoryListTile extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CategoryListTile({
    required this.category,
    required this.onTap,
    required this.onDelete,
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
      trailing: IconButton(
        icon: Icon(Icons.delete_outline_rounded),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
