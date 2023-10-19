import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_breakdown.dart';
import 'month_summary_chart.dart';
import 'month_summary_card.dart';

class MonthSummaryCardContent extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  const MonthSummaryCardContent({super.key, 
    required this.monthSummary,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    final monthCost = monthSummary.totalCostBy();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context: context, monthCost: monthCost),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: MonthSummaryChart(
            monthSummary: monthSummary,
            textToColor: textToColor,
          ),
        ),
        const SizedBox(height: 16),
        _footer(
          monthSummary: monthSummary,
          textToColor: textToColor,
        ),
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
        Text(monthCost.toLocalString(), style: textTheme.headlineSmall),
        Text(
          monthName,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _footer({
    required MonthSummary monthSummary,
    required TextToColor textToColor,
  }) {
    final categoryCosts = Map.fromEntries(monthSummary.categories
        .map((c) => MapEntry(c, monthSummary.totalCostBy(category: c))));

    return CategoryBreakdown(
      categoryCosts: categoryCosts,
      textToColor: textToColor,
    );
  }
}
