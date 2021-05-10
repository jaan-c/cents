import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'fixed_grid.dart';
import 'month_summary_bar_chart.dart';
import 'month_summary_card.dart';

class MonthSummaryCardContent extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  MonthSummaryCardContent({
    required this.monthSummary,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context: context, monthSummary: monthSummary),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: MonthSummaryBarChart(
            monthSummary: monthSummary,
            textToColor: textToColor,
          ),
        ),
        SizedBox(height: 16),
        _footer(
          context: context,
          monthSummary: monthSummary,
          textToColor: textToColor,
        ),
      ],
    );
  }

  Widget _header({
    required BuildContext context,
    required MonthSummary monthSummary,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final grandTotal = monthSummary.totalCostBy();
    final monthName = DateFormat.MMMM()
        .format(DateTime(monthSummary.year, monthSummary.month));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(grandTotal.toLocalString(), style: textTheme.headline5),
        Text(
          monthName,
          style: textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _footer({
    required BuildContext context,
    required MonthSummary monthSummary,
    required TextToColor textToColor,
  }) {
    final categories = monthSummary.getAllCategories();
    final categoryCosts = Map.fromEntries(categories
        .map((c) => MapEntry(c, monthSummary.totalCostBy(category: c))));

    return FixedGrid(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final category in categories)
          _footerTile(
            context: context,
            category: category,
            cost: categoryCosts[category]!,
            textToColor: textToColor,
          )
      ],
    );
  }

  Widget _footerTile({
    required BuildContext context,
    required ExpenseCategory category,
    required Amount cost,
    required TextToColor textToColor,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          color: textToColor(theme.brightness, category.name),
          size: 12,
        ),
        SizedBox(width: 8),
        DefaultTextStyle(
          style: textTheme.bodyText2!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name),
              Text(cost.toLocalString()),
            ],
          ),
        ),
      ],
    );
  }
}
