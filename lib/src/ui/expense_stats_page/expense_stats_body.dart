import 'package:cents/src/ui/widgets/month_summary_card.dart';
import 'package:flutter/material.dart';

import 'expense_stats_body_controller.dart';

class ExpenseStatsBody extends StatefulWidget {
  final ExpenseStatsBodyController controller;

  ExpenseStatsBody({required this.controller});

  @override
  _ExpenseStatsBodyState createState() =>
      _ExpenseStatsBodyState(controller: controller);
}

class _ExpenseStatsBodyState extends State<ExpenseStatsBody> {
  final ExpenseStatsBodyController controller;

  _ExpenseStatsBodyState({required this.controller});

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
        Padding(
          padding: const EdgeInsets.all(16),
          child: _header(context),
        ),
        if (controller.selectedYearSummary != null)
          Expanded(child: _monthSummaryCards()),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '${controller.selectedYear} Summary',
            style: textTheme.headline5,
          ),
        ),
        IconButton(
          icon: Icon(Icons.navigate_before_outlined),
          onPressed:
              controller.hasPreviousYear ? controller.selectPreviousYear : null,
        ),
        IconButton(
          icon: Icon(Icons.navigate_next_rounded),
          onPressed: controller.hasNextYear ? controller.selectNextYear : null,
        ),
      ],
    );
  }

  Widget _monthSummaryCards() {
    final yearSummary = controller.selectedYearSummary!;
    final months = yearSummary.getAllMonths();

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, ix) {
        final month = months[ix];
        final monthSummary = yearSummary.getMonthSummary(month)!;

        return MonthSummaryCard(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          monthSummary: monthSummary,
        );
      },
    );
  }
}
