import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_cost_grid.dart';
import 'month_summary_card.dart';
import 'week_summary_chart.dart';

class WeekSummaryCardContent extends StatelessWidget {
  final MonthSummary monthSummary;
  final WeekOfMonth weekOfMonth;
  final TextToColor textToColor;

  WeekSummaryCardContent({
    required this.monthSummary,
    required this.weekOfMonth,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    final weekCost = monthSummary.totalCostBy(weekOfMonth: weekOfMonth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          context: context,
          month: monthSummary.month,
          weekOfMonth: weekOfMonth,
          weekCost: weekCost,
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: WeekSummaryChart(
            monthSummary: monthSummary,
            weekOfMonth: weekOfMonth,
            textToColor: textToColor,
          ),
        ),
        SizedBox(height: 16),
        _footer(
          monthSummary: monthSummary,
          weekofMonth: weekOfMonth,
          textToColor: textToColor,
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

  Widget _footer({
    required MonthSummary monthSummary,
    required WeekOfMonth weekofMonth,
    required TextToColor textToColor,
  }) {
    final categories = monthSummary.getAllCategories();
    final categoryCosts = Map.fromEntries(categories.map((c) => MapEntry(
        c, monthSummary.totalCostBy(category: c, weekOfMonth: weekofMonth))));

    return CategoryCostGrid(
      categoryCosts: categoryCosts,
      textToColor: textToColor,
    );
  }
}
