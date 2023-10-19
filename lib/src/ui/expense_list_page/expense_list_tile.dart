import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/ext_date_time.dart';
import 'package:cents/src/domain/ext_string.dart';
import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const ExpenseListTile({super.key, 
    required this.expense,
    required this.onTap,
    this.onLongPress,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectColor = colorScheme.onSurface.withAlpha(33);

    return Material(
      color: isSelected ? selectColor : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createdAtText(context),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(child: _categoryText(context)),
                  _costText(context),
                ],
              ),
              if (expense.note.isNotBlank) _noteText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createdAtText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.createdAt.relativeDisplay(), style: textTheme.labelSmall);
  }

  Widget _categoryText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      expense.category.name.isNotBlank
          ? expense.category.name
          : 'Uncategorized',
      style: textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _costText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.cost.toLocalString(), style: textTheme.titleMedium);
  }

  Widget _noteText(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final brightness = theme.brightness;
    final textColor =
        brightness == Brightness.light ? Colors.black54 : Colors.white54;

    return Text(
      expense.note,
      style: textTheme.bodyMedium?.apply(color: textColor),
    );
  }
}
