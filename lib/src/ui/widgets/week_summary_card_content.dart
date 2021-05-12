import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/pair.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'month_summary_card.dart';
import 'week_summary_bar_chart.dart';

class WeekSummaryCardContent extends StatelessWidget {
  final int month;
  final WeekOfMonth weekOfMonth;
  final List<Pair<ExpenseCategory, Amount>> categoryCosts;
  final TextToColor textToColor;

  WeekSummaryCardContent({
    required this.month,
    required this.weekOfMonth,
    required this.categoryCosts,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    final weekCost = categoryCosts
        .map((pair) => pair.second)
        .fold<Amount>(Amount(), (acc, cost) => acc.add(cost));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          context: context,
          month: month,
          weekOfMonth: weekOfMonth,
          weekCost: weekCost,
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: WeekSummaryBarChart(
            categoryCosts: categoryCosts,
            textToColor: textToColor,
          ),
        ),
      ],
    );
  }

  Widget _header({
    required BuildContext context,
    required int month,
    required WeekOfMonth weekOfMonth,
    required Amount weekCost,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final monthName = DateFormat.MMMM().format(DateTime(2000, month));
    final weekOfMonthOrdinal = weekOfMonth.toOrdinalString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(weekCost.toLocalString(), style: textTheme.headline5),
        Text(
          '$weekOfMonthOrdinal of $monthName',
          style: textTheme.bodyText2,
        ),
      ],
    );
  }
}
