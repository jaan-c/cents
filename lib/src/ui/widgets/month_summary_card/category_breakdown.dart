import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:flutter/material.dart';

import 'month_summary_card.dart';

class CategoryBreakdown extends StatelessWidget {
  final Map<ExpenseCategory, Amount> categoryCosts;
  final TextToColor textToColor;

  CategoryBreakdown({
    required Map<ExpenseCategory, Amount> categoryCosts,
    required this.textToColor,
  }) : categoryCosts = Map.fromEntries(
            categoryCosts.entries.where((cc) => cc.value != Amount()));

  @override
  Widget build(BuildContext context) {
    final categories = categoryCosts.keys.toList()..sort();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final category in categories)
          _categoryCostChip(
            context: context,
            category: category,
            cost: categoryCosts[category]!,
            textToColor: textToColor,
          ),
      ],
    );
  }

  Widget _categoryCostChip({
    required BuildContext context,
    required ExpenseCategory category,
    required Amount cost,
    required TextToColor textToColor,
  }) {
    final brightness = Theme.of(context).brightness;

    final categoryColor = textToColor(brightness, category.name);
    final categoryName =
        category.name.isNotEmpty ? category.name : 'Uncategorized';

    return _outlineBulletChip(
      context: context,
      bulletColor: categoryColor,
      title: categoryName,
      subtitle: cost.toLocalString(),
    );
  }

  Widget _outlineBulletChip({
    required BuildContext context,
    required Color bulletColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final textTheme = theme.textTheme;
    final borderColor =
        brightness == Brightness.light ? Colors.black12 : Colors.white10;

    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 12, 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.circle_rounded,
            color: bulletColor,
            size: 16,
          ),
          SizedBox(width: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100),
            child: DefaultTextStyle(
              style: textTheme.bodyText2!.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(subtitle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
