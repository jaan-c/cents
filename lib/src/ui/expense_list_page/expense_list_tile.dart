import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/ext_date_time.dart';
import 'package:cents/src/domain/ext_string.dart';
import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  ExpenseListTile({
    required this.expense,
    required this.onTap,
    this.onLongPress,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _embellishment(
      context: context,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _categoryColorIcon(),
            SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _createdAtOverline(context: context),
                  _categoryAndCostText(context: context),
                  if (expense.note.isNotBlank) _noteText(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _embellishment({
    required BuildContext context,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectColor = colorScheme.onSurface.withAlpha(33);

    return Material(
      color: isSelected ? selectColor : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }

  Widget _categoryColorIcon() {
    return Icon(
      Icons.circle_rounded,
      color: expense.category.color,
    );
  }

  Widget _createdAtOverline({required BuildContext context}) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.createdAt.relativeDisplay(), style: textTheme.overline);
  }

  Widget _categoryAndCostText({required BuildContext context}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: _categoryText(context: context),
        ),
        _costText(context: context),
      ],
    );
  }

  Widget _categoryText({required BuildContext context}) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      expense.category.name.isNotBlank
          ? expense.category.name
          : 'Uncategorized',
      style: textTheme.subtitle1,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _costText({required BuildContext context}) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.cost.toLocalString(), style: textTheme.subtitle1);
  }

  Widget _noteText(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final brightness = theme.brightness;
    final textColor =
        brightness == Brightness.light ? Colors.black54 : Colors.white54;

    return Text(
      expense.note,
      style: textTheme.bodyText2?.apply(color: textColor),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
