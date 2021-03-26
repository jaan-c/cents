import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;

  ExpenseListTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _categoryText(context),
      trailing: _costText(context),
      subtitle: expense.note.isNotEmpty ? _noteText(context) : null,
    );
  }

  Widget _categoryText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.category.name, style: textTheme.subtitle1);
  }

  Widget _costText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final content =
        '\u20B1${expense.cost.units}.${expense.cost.cents.toString().padLeft(2, '0')}';

    return Text(content, style: textTheme.subtitle1);
  }

  Widget _noteText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(expense.note, style: textTheme.subtitle2);
  }
}
