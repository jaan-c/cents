import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/ext_date.dart';
import 'package:cents/src/domain/ext_string.dart';
import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  ExpenseListTile(
      {required this.expense,
      required this.onTap,
      this.onLongPress,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colorScheme.onSurface.withAlpha(33) : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.all(16),
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
    final content = expense.createdAt.relativeDisplay();

    final textTheme = Theme.of(context).textTheme;

    return Text(content, style: textTheme.overline);
  }

  Widget _categoryText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
        expense.category.name.isNotBlank
            ? expense.category.name
            : 'Uncategorized',
        style: textTheme.subtitle1);
  }

  Widget _costText(BuildContext context) {
    final content = '\u20B1${expense.cost}';

    final textTheme = Theme.of(context).textTheme;

    return Text(content, style: textTheme.subtitle1);
  }

  Widget _noteText(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Text(
      expense.note,
      style: textTheme.bodyText2
          ?.apply(color: colorScheme.onSurface.withOpacity(0.6)),
    );
  }
}
