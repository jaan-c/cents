import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';
import '../util/datetime.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;

  ExpenseListTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          _noteText(context),
        ],
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

    return Text(expense.category.name, style: textTheme.subtitle1);
  }

  Widget _costText(BuildContext context) {
    final content = '\u20B1$expense';

    final textTheme = Theme.of(context).textTheme;

    return Text(content, style: textTheme.subtitle1);
  }

  Widget _noteText(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Text(
      expense.note,
      style: textTheme.subtitle2
          ?.apply(color: theme.colorScheme.onSurface.withOpacity(0.6)),
    );
  }
}
