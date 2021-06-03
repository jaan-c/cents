import 'package:cents/src/ui/widgets/month_summary_card/month_summary_card.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';

import 'expense_list_page_model.dart';
import 'sliver_expense_list.dart';

const _FAB_SIZE = 56.0;
const _FAB_PADDING = 16.0;

class ExpenseListPage extends StatefulWidget {
  final ExpenseListPageModel model;

  ExpenseListPage({required this.model});

  @override
  _ExpenseListPageState createState() => _ExpenseListPageState(model);
}

class _ExpenseListPageState
    extends StateWithModel<ExpenseListPage, ExpenseListPageModel> {
  @override
  final ExpenseListPageModel model;

  _ExpenseListPageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(
        onOpenStats: () => model.navigateToStats(context),
        onOpenSettings: () => model.navigateToSettings(context),
      ),
      body: CustomScrollView(
        slivers: [
          if (model.currentMonthSummary.isNotEmpty)
            SliverToBoxAdapter(
              child: MonthSummaryCard(
                monthSummary: model.currentMonthSummary,
                mode: MonthSummaryCardMode.week,
                margin: EdgeInsets.all(8),
              ),
            ),
          if (model.expenses.isNotEmpty) ...[
            _sliverListSubheader(
              context: context,
              subheaderText: 'Recent Expenses',
            ),
            SliverExpenseList(
              expenses: model.expenses,
              expenseSelection: model.expenseSelection,
              onToggleExpense: model.toggleSelectExpense,
              onEditExpense: (expenseId) =>
                  model.navigateToEditor(context, expenseId),
            ),
          ],
          _sliverBottomOffset(bottomOffsetHeight: _FAB_SIZE + _FAB_PADDING),
        ],
      ),
      floatingActionButton: _addExpenseFab(
        onPressed: () => model.navigateToEditor(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar({
    required VoidCallback onOpenStats,
    required VoidCallback onOpenSettings,
  }) {
    return AppBar(
      title: Text('Cents'),
      actions: [
        IconButton(
          onPressed: onOpenStats,
          icon: Icon(Icons.table_chart_rounded),
        ),
        IconButton(
          onPressed: onOpenSettings,
          icon: Icon(Icons.settings_rounded),
        ),
      ],
    );
  }

  Widget _sliverListSubheader({
    required BuildContext context,
    required String subheaderText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SliverToBoxAdapter(
      child: ListTile(
        title: Text(
          subheaderText,
          style: textTheme.subtitle2?.apply(color: colorScheme.secondary),
        ),
        dense: true,
      ),
    );
  }

  Widget _sliverBottomOffset({required double bottomOffsetHeight}) {
    return SliverToBoxAdapter(
      child: SizedBox(height: bottomOffsetHeight),
    );
  }

  Widget _addExpenseFab({required VoidCallback onPressed}) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(Icons.add_rounded),
      label: Text('Add Expense'),
    );
  }
}
