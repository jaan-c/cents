import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';

import 'fixed_grid.dart';
import 'month_summary_card.dart';

class CategoryCostGrid extends StatelessWidget {
  final Map<ExpenseCategory, Amount> categoryCosts;
  final TextToColor textToColor;

  CategoryCostGrid({
    required this.categoryCosts,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    final categories = categoryCosts.keys.toList()
      ..removeWhere((c) => categoryCosts[c] == Amount())
      ..sort();

    return FixedGrid(
      crossAxisCount: 3,
      children: [
        for (final category in categories)
          _categoryCostTile(
            context: context,
            category: category,
            cost: categoryCosts[category]!,
            textToColor: textToColor,
          ),
      ],
    );
  }

  Widget _categoryCostTile({
    required BuildContext context,
    required ExpenseCategory category,
    required Amount cost,
    required TextToColor textToColor,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          color: textToColor(theme.brightness, category.name),
          size: 12,
        ),
        SizedBox(width: 8),
        DefaultTextStyle(
          style: textTheme.bodyText2!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name.isNotEmpty ? category.name : 'Uncategorized'),
              Text(cost.toLocalString()),
            ],
          ),
        ),
      ],
    );
  }
}
