import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_breakdown.dart';
import 'month_summary_chart.dart';

class MonthSummaryCardContent extends StatelessWidget {
  final MonthSummary monthSummary;

  MonthSummaryCardContent({required this.monthSummary});

  @override
  Widget build(BuildContext context) {
    final monthCost = monthSummary.totalCostBy();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context: context, monthCost: monthCost),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: MonthSummaryChart(monthSummary: monthSummary),
        ),
        SizedBox(height: 16),
        _footer(monthSummary: monthSummary),
      ],
    );
  }

  Widget _header({
    required BuildContext context,
    required Amount monthCost,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final monthName = DateFormat.MMMM()
        .format(DateTime(monthSummary.year, monthSummary.month));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(monthCost.toLocalString(), style: textTheme.headline5),
        Text(
          monthName,
          style: textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _footer({required MonthSummary monthSummary}) {
    final categoryCosts = Map.fromEntries(monthSummary.categories
        .map((c) => MapEntry(c, monthSummary.totalCostBy(category: c))));

    return CategoryBreakdown(
      categoryCosts: categoryCosts,
    );
  }
}
