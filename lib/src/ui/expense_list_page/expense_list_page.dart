import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:cents/src/ui/widgets/summary_card/month_summary.dart';
import 'package:cents/src/ui/widgets/summary_card/month_summary_view.dart';
import 'package:cents/src/ui/widgets/summary_card/week_summary_view.dart';
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
      appBar: !model.hasSelectedExpense
          ? _appBar(
              onOpenAllExpenses: () => model.navigateToAllExpenses(context),
              onOpenCategories: () => model.navigateToCategories(context),
              onOpenSettings: () => model.navigateToSettings(context),
            )
          : _appBarSelection(
              selectedCount: model.selectedExpenses.length,
              onClearSelected: model.clearSelectedExpenses,
              onDeleteSelected: model.deleteSelectedExpenses,
            ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _summaryCard(
              mode: model.summaryCardMode,
              onSwitchMode: model.switchSummaryCardMode,
              child: model.summaryCardMode == SummaryCardMode.week
                  ? WeekSummaryView(
                      weekRange: model.weekRange,
                      expenses: model.expenses,
                      onSetWeekRange: model.setWeekRange,
                    )
                  : MonthSummaryView(
                      monthSummary:
                          MonthSummary(model.monthRange, model.expenses),
                      onSetMonthRange: model.setMonthRange,
                    ),
            ),
          ),
          SliverExpenseList(
            expenses: model.expenses,
            selectedExpenses: model.selectedExpenses,
            onToggleSelect: model.toggleSelectExpense,
            onEditExpense: (expenseId) =>
                model.navigateToEditor(context, expenseId),
          ),
          _sliverBottomOffset(bottomOffsetHeight: _FAB_SIZE + _FAB_PADDING),
        ],
      ),
      floatingActionButton: !model.hasSelectedExpense
          ? _addExpenseFab(
              onPressed: () => model.navigateToEditor(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar({
    required VoidCallback onOpenAllExpenses,
    required VoidCallback onOpenCategories,
    required VoidCallback onOpenSettings,
  }) {
    return AppBar(
      title: Text('Cents'),
      actions: [
        IconButton(
          onPressed: onOpenAllExpenses,
          icon: Icon(Icons.list_alt_rounded),
        ),
        IconButton(
          onPressed: onOpenCategories,
          icon: Icon(Icons.category_rounded),
        ),
        IconButton(
          onPressed: onOpenSettings,
          icon: Icon(Icons.settings_rounded),
        ),
      ],
    );
  }

  AppBar _appBarSelection({
    required int selectedCount,
    required VoidCallback onClearSelected,
    required VoidCallback onDeleteSelected,
  }) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: onClearSelected,
      ),
      title: Text('$selectedCount selected'),
      actions: [
        IconButton(
          icon: Icon(Icons.delete_rounded),
          onPressed: onDeleteSelected,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required SummaryCardMode mode,
    required VoidCallback onSwitchMode,
    required Widget child,
  }) {
    final switcherChip = ActionChip(
      label: Text(
        mode == SummaryCardMode.week ? 'Week Summary' : 'Month Summary',
      ),
      onPressed: onSwitchMode,
    );

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            switcherChip,
            SizedBox(height: 8),
            child,
          ],
        ),
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
