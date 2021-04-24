import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/widgets/shared/month_summary_card.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';

typedef OpenEditorCallback = void Function(int expenseId);
typedef SelectExpenseCallback = void Function(Expense);
typedef DeselectExpenseCallback = void Function(Expense);
typedef DeleteExpensesCallback = void Function(List<int> expenseIds);

class ExpenseListPageScaffold extends StatelessWidget {
  final DateTime currentDate;
  final List<Expense> allExpenses;
  final Set<Expense> expenseSelection;
  final SelectExpenseCallback onSelectExpense;
  final DeselectExpenseCallback onDeselectExpense;
  final DeleteExpensesCallback onDeleteExpenses;
  final OpenEditorCallback onOpenEditor;

  final MonthSummary? currentMonthSummary;

  ExpenseListPageScaffold(
      {required this.currentDate,
      required this.allExpenses,
      required this.expenseSelection,
      required this.onSelectExpense,
      required this.onDeselectExpense,
      required this.onDeleteExpenses,
      required this.onOpenEditor})
      : currentMonthSummary =
            Summary(allExpenses).getMonth(currentDate.year, currentDate.month);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (currentMonthSummary != null) _currentMonthSummaryCard(),
          Expanded(child: _expenseList()),
        ],
      ),
      floatingActionButton:
          expenseSelection.isEmpty ? _addExpenseFab(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: expenseSelection.isEmpty
          ? _bottomBar()
          : _selectionBottomBar(context),
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

  Widget _currentMonthSummaryCard() {
    return MonthSummaryCard(monthSummary: currentMonthSummary!);
  }

  Widget _expenseList() {
    return ExpenseList(
      expenses: allExpenses,
      expenseSelection: expenseSelection,
      onEditExpense: onOpenEditor,
      onSelectExpense: onSelectExpense,
      onDeselectExpense: onDeselectExpense,
      subheader: Text('All Expenses'),
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
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Spacer(), _overflowMenuButton()],
        ),
      ),
    );
  }

  Widget _selectionBottomBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BottomAppBar(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${expenseSelection.length} selected',
                  style: textTheme.headline6,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded),
              onPressed: () =>
                  onDeleteExpenses(expenseSelection.map((e) => e.id).toList()),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded),
              onPressed: () => expenseSelection.forEach(onDeselectExpense),
            ),
          ],
        ),
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
