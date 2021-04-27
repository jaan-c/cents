import 'package:cents/src/ui/widgets/month_summary_card.dart';
import 'package:flutter/material.dart';

import 'expense_list.dart';
import 'expense_list_body_controller.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (controller.currentMonthSummary != null) ...[
          _currentMonthSummaryCard(),
          SizedBox(height: 8),
        ],
        Expanded(child: _expenseList()),
      ],
    );
  }

  Widget _currentMonthSummaryCard() {
    return MonthSummaryCard(
      monthSummary: controller.currentMonthSummary!,
      margin: EdgeInsets.all(8),
    );
  }

  Widget _expenseList() {
    return ExpenseList(
      expenses: controller.allExpenses,
      expenseSelection: controller.expenseSelection,
      onEditExpense: controller.openEditor,
      onSelectExpense: controller.selectExpense,
      onDeselectExpense: controller.deselectExpense,
      subheader: Text('All Expenses'),
    );
  }
}
