import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_breakdown.dart';
import 'month_summary.dart';
import 'month_summary_chart.dart';

typedef SetMonthRangeCallback = void Function(MonthRange);

class MonthSummaryView extends StatelessWidget {
  final MonthRange monthRange;
  final List<Expense> expenses;
  final SetMonthRangeCallback onSetMonthRange;

  MonthSummaryView({
    required this.monthRange,
    required this.expenses,
    required this.onSetMonthRange,
  }) : assert(expenses.every((e) => monthRange.isInRange(e.createdAt)));

  @override
  Widget build(BuildContext context) {
    final monthSummary = MonthSummary(
      monthRange.start.year,
      monthRange.start.month,
      expenses,
    );
    final monthCost = monthSummary.totalCostBy();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          context: context,
          monthCost: monthCost,
          monthRange: monthRange,
          onSetMonthRange: onSetMonthRange,
        ),
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
    required MonthRange monthRange,
    required SetMonthRangeCallback onSetMonthRange,
  }) {
    final previousMonthRange = monthRange.previous;
    final nextMonthRange = monthRange.next;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onSetMonthRange(previousMonthRange),
          icon: Icon(Icons.navigate_before_rounded),
        ),
        Expanded(
          child: _headerTitle(
            context: context,
            monthRange: monthRange,
            monthCost: monthCost,
          ),
        ),
        IconButton(
          onPressed: () => onSetMonthRange(nextMonthRange),
          icon: Icon(Icons.navigate_next_rounded),
        ),
      ],
    );
  }

  Widget _headerTitle({
    required BuildContext context,
    required MonthRange monthRange,
    required Amount monthCost,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final monthLabel =
        DateFormat.MMMM().format(DateTime(monthRange.year, monthRange.month));
    final enDash = '\u2013';
    final monthRangeLabel =
        '${DateFormat.MMMd().format(monthRange.start)}$enDash${DateFormat.MMMd().format(monthRange.end)}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(monthCost.toLocalString(), style: textTheme.headline5),
        Text(monthLabel, style: textTheme.bodyText2),
        Text(monthRangeLabel, style: textTheme.bodyText2),
      ],
    );
  }

  Widget _footer({required MonthSummary monthSummary}) {
    final categoryCosts = Map.fromEntries(monthSummary.categories
        .map((c) => MapEntry(c, monthSummary.totalCostBy(category: c))));

    return CategoryBreakdown(categoryCosts: categoryCosts);
  }
}
