import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list_page_scaffold.dart';
import 'expense_list_tile.dart';
import 'edit_expense_callback.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Set<Expense> expenseSelection;
  final EditExpenseCallback onEditExpense;
  final SelectExpenseCallback onSelectExpense;
  final DeselectExpenseCallback onDeselectExpense;
  final Widget? subheader;

  bool get isSelectionMode => expenseSelection.isNotEmpty;

  ExpenseList(
      {required this.expenses,
      required this.expenseSelection,
      required this.onEditExpense,
      required this.onSelectExpense,
      required this.onDeselectExpense,
      this.subheader});

  @override
  Widget build(BuildContext context) {
    final headerOffset = 1;

    return ListView.separated(
      itemBuilder: (context, ix) {
        if (ix == 0) {
          return _subheader(context);
        }

        final e = expenses[ix - headerOffset];

        if (!isSelectionMode) {
          return ExpenseListTile(
            expense: e,
            onTap: () => onEditExpense(e.id),
            onLongPress: () => onSelectExpense(e),
            isSelected: false,
          );
        } else {
          final isSelected = expenseSelection.contains(e);

          return ExpenseListTile(
            expense: e,
            onTap: !isSelected
                ? () => onSelectExpense(e)
                : () => onDeselectExpense(e),
            isSelected: isSelected,
          );
        }
      },
      separatorBuilder: (_, ix) {
        if (ix == 0) {
          return SizedBox.shrink();
        } else {
          return Divider(height: 1);
        }
      },
      itemCount: expenses.length + headerOffset,
    );
  }

  Widget _subheader(BuildContext context) {
    if (subheader == null) {
      return SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DefaultTextStyle(
        style: textTheme.subtitle2!.copyWith(color: colorScheme.primary),
        child: subheader!,
      ),
    );
  }
}
