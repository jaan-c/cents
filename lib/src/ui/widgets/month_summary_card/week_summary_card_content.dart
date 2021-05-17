import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:cents/src/domain/ext_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_cost_grid.dart';
import 'month_summary_card.dart';
import 'week_summary_chart.dart';

// FIXME: Hoist state up MonthSummaryCard to simplify widget configuration changes.
class WeekSummaryCardContent extends StatefulWidget {
  final MonthSummary monthSummary;
  final WeekOfMonth? weekOfMonth;
  final TextToColor textToColor;

  WeekSummaryCardContent({
    required this.monthSummary,
    this.weekOfMonth,
    required this.textToColor,
  });

  @override
  _WeekSummaryCardContentState createState() => _WeekSummaryCardContentState(
      monthSummary: monthSummary,
      weekOfMonth: weekOfMonth,
      textToColor: textToColor);
}

class _WeekSummaryCardContentState extends State<WeekSummaryCardContent> {
  MonthSummary monthSummary;
  WeekOfMonth weekOfMonth;
  TextToColor textToColor;

  _WeekSummaryCardContentState._internal({
    required this.monthSummary,
    required WeekOfMonth weekOfMonth,
    required this.textToColor,
  }) : weekOfMonth = weekOfMonth;

  factory _WeekSummaryCardContentState({
    required MonthSummary monthSummary,
    WeekOfMonth? weekOfMonth,
    required TextToColor textToColor,
  }) {
    final now = DateTime.now();
    if (weekOfMonth == null &&
        monthSummary.year == now.year &&
        monthSummary.month == now.month) {
      return _WeekSummaryCardContentState._internal(
        monthSummary: monthSummary,
        weekOfMonth: now.weekOfMonth,
        textToColor: textToColor,
      );
    }

    return _WeekSummaryCardContentState._internal(
      monthSummary: monthSummary,
      weekOfMonth: weekOfMonth ?? WeekOfMonth.first,
      textToColor: textToColor,
    );
  }

  @override
  void didUpdateWidget(covariant WeekSummaryCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      monthSummary = widget.monthSummary;
      weekOfMonth = widget.weekOfMonth ?? WeekOfMonth.first;
      textToColor = widget.textToColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          context: context,
          monthSummary: monthSummary,
          weekOfMonth: weekOfMonth,
          onChangeWeekOfMonth: (w) => setState(() {
            weekOfMonth = w;
          }),
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
    required MonthSummary monthSummary,
    required WeekOfMonth weekOfMonth,
    required void Function(WeekOfMonth) onChangeWeekOfMonth,
  }) {
    final weeks = monthSummary.getAllWeeks();
    final hasPreviousWeek = weekOfMonth != weeks.first;
    final hasNextWeek = weekOfMonth != weeks.last;
    final onPreviousWeek = () {
      final currentIndex = weeks.indexOf(weekOfMonth);
      final previousWeek = weeks[currentIndex - 1];
      onChangeWeekOfMonth(previousWeek);
    };
    final onNextweek = () {
      final currentIndex = weeks.indexOf(weekOfMonth);
      final nextWeek = weeks[currentIndex + 1];
      onChangeWeekOfMonth(nextWeek);
    };

    final weekCost = monthSummary.totalCostBy(weekOfMonth: weekOfMonth);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.navigate_before_rounded),
          onPressed: hasPreviousWeek ? onPreviousWeek : null,
        ),
        Expanded(
          child: _headerTitle(
            context: context,
            month: monthSummary.month,
            weekOfMonth: weekOfMonth,
            weekCost: weekCost,
          ),
        ),
        IconButton(
          icon: Icon(Icons.navigate_next_rounded),
          onPressed: hasNextWeek ? onNextweek : null,
        ),
      ],
    );
  }

  Widget _headerTitle({
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
          '$weekOfMonthOrdinal week of $monthName',
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
