import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category_breakdown.dart';
import 'month_summary_card.dart';
import 'week_summary_chart.dart';

typedef ChangeWeekOfMonthCallback = void Function(WeekOfMonth);

class WeekSummaryCardContent extends StatelessWidget {
  final MonthSummary monthSummary;
  final WeekOfMonth weekOfMonth;
  final ChangeWeekOfMonthCallback onChangeWeekOfMonth;
  final TextToColor textToColor;

  const WeekSummaryCardContent({super.key, 
    required this.monthSummary,
    required this.weekOfMonth,
    required this.onChangeWeekOfMonth,
    required this.textToColor,
  });

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
          onChangeWeekOfMonth: onChangeWeekOfMonth,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: WeekSummaryChart(
            monthSummary: monthSummary,
            weekOfMonth: weekOfMonth,
            textToColor: textToColor,
          ),
        ),
        const SizedBox(height: 16),
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
    required ChangeWeekOfMonthCallback onChangeWeekOfMonth,
  }) {
    final weeks = monthSummary.weeks;
    final hasPreviousWeek = weekOfMonth != weeks.first;
    final hasNextWeek = weekOfMonth != weeks.last;
    onPreviousWeek() {
      final currentIndex = weeks.indexOf(weekOfMonth);
      final previousWeek = weeks[currentIndex - 1];
      onChangeWeekOfMonth(previousWeek);
    }
    onNextweek() {
      final currentIndex = weeks.indexOf(weekOfMonth);
      final nextWeek = weeks[currentIndex + 1];
      onChangeWeekOfMonth(nextWeek);
    }

    final weekCost = monthSummary.totalCostBy(weekOfMonth: weekOfMonth);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.navigate_before_rounded),
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
          icon: const Icon(Icons.navigate_next_rounded),
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
        Text(weekCost.toLocalString(), style: textTheme.headlineSmall),
        Text(
          '$weekOfMonthOrdinal week of $monthName',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _footer({
    required MonthSummary monthSummary,
    required WeekOfMonth weekofMonth,
    required TextToColor textToColor,
  }) {
    final categoryCosts = Map.fromEntries(monthSummary.categories.map((c) =>
        MapEntry(c,
            monthSummary.totalCostBy(category: c, weekOfMonth: weekofMonth))));

    return CategoryBreakdown(
      categoryCosts: categoryCosts,
      textToColor: textToColor,
    );
  }
}
