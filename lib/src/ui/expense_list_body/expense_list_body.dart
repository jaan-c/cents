import 'package:cents/src/ui/widgets/month_summary_card/month_summary_card.dart';
import 'package:flutter/material.dart';

import 'expense_list_body_controller.dart';
import 'sliver_expense_list.dart';

const _FAB_SIZE = 56.0;
const _FAB_PADDING = 16.0;

class ExpenseListBody extends StatefulWidget {
  final ExpenseListBodyController controller;

  ExpenseListBody({required this.controller});

  @override
  _ExpenseListBodyState createState() =>
      _ExpenseListBodyState(controller: controller);
}

class _ExpenseListBodyState extends State<ExpenseListBody> {
  final ExpenseListBodyController controller;

  _ExpenseListBodyState({required this.controller});

  @override
  void initState() {
    super.initState();

    controller.addListener(_onControllerMutation);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerMutation);

    super.dispose();
  }

  void _onControllerMutation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (controller.currentMonthSummary != null)
          SliverToBoxAdapter(
            child: MonthSummaryCard(
              monthSummary: controller.currentMonthSummary!,
              mode: MonthSummaryCardMode.week,
              margin: EdgeInsets.all(8),
            ),
          ),
        if (controller.allExpenses.isNotEmpty) ...[
          _sliverSubheader(
            context: context,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          ),
          SliverExpenseList(
            expenses: controller.allExpenses,
            expenseSelection: controller.expenseSelection,
            onToggleExpense: (expense) => controller.toggleExpense(expense),
            onEditExpense: (expenseId) => controller.openEditor(expenseId),
          ),
        ],
        _sliverFabPadding(),
      ],
    );
  }

  Widget _sliverSubheader({
    required BuildContext context,
    required EdgeInsetsGeometry padding,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: padding,
        child: Text(
          'Recent Expenses',
          style: textTheme.subtitle2!.copyWith(color: colorScheme.secondary),
        ),
      ),
    );
  }

  Widget _sliverFabPadding() {
    return SliverToBoxAdapter(
      child: SizedBox(height: _FAB_SIZE + _FAB_PADDING),
    );
  }
}
