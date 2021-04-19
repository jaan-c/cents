import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';

typedef OpenEditorCallback = void Function(int expenseId);

class ExpenseListPageScaffold extends StatelessWidget {
  final List<Expense> allExpenses;
  final OpenEditorCallback onOpenEditor;

  ExpenseListPageScaffold(
      {required this.allExpenses, required this.onOpenEditor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ExpenseList(
        expenses: allExpenses,
        onEditExpense: onOpenEditor,
      ),
      floatingActionButton: _addExpenseFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(),
    );
  }

  AppBar _appBar(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      title: Text(
        'Expenses',
        style: textTheme.headline6?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _addExpenseFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onOpenEditor(Expense.UNSET_ID),
      child: Icon(Icons.add),
    );
  }

  Widget _bottomBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Spacer(), _overflowMenuButton()],
      ),
    );
  }

  Widget _overflowMenuButton() {
    return PopupMenuButton(
      itemBuilder: (_) {
        return ['Settings', 'About']
            .map((x) => PopupMenuItem(value: x, child: Text(x)))
            .toList();
      },
    );
  }
}
