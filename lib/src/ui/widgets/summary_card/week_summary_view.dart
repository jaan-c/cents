import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';

import 'category_breakdown.dart';
import 'week_summary.dart';
import 'week_summary_chart.dart';

typedef SetWeekRangeCallback = void Function(WeekRange);

class WeekSummaryView extends StatelessWidget {
  final WeekRange weekRange;
  final List<Expense> expenses;
  final SetWeekRangeCallback onSetWeekRange;

  WeekSummaryView({
    required this.weekRange,
    required this.expenses,
    required this.onSetWeekRange,
  }) : assert(expenses.every((e) => weekRange.isInRange(e.createdAt)));

  @override
  Widget build(BuildContext context) {
    final weekSummary = WeekSummary(
      weekRange.start.year,
      Week.fromDate(weekRange.start).weekNumber,
      expenses,
    );
    final weekCost = weekSummary.totalCostBy();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          context: context,
          weekCost: weekCost,
          weekRange: weekRange,
          onSetWeekRange: onSetWeekRange,
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 150,
          child: WeekSummaryChart(weekSummary: weekSummary),
        ),
        SizedBox(height: 16),
        _footer(weekSummary: weekSummary),
      ],
    );
  }

  Widget _header({
    required BuildContext context,
    required Amount weekCost,
    required WeekRange weekRange,
    required SetWeekRangeCallback onSetWeekRange,
  }) {
    final previousWeekRange = weekRange.previous;
    final nextWeekRange = weekRange.next;

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onSetWeekRange(previousWeekRange),
          icon: Icon(Icons.navigate_before_rounded),
        ),
        Expanded(
          child: _headerTitle(
            context: context,
            weekRange: weekRange,
            weekCost: weekCost,
          ),
        ),
        IconButton(
          onPressed: () => onSetWeekRange(nextWeekRange),
          icon: Icon(Icons.navigate_next_rounded),
        ),
      ],
    );
  }

  Widget _headerTitle({
    required BuildContext context,
    required WeekRange weekRange,
    required Amount weekCost,
  }) {
    final textTheme = Theme.of(context).textTheme;

    // 1st week of Aug
    final monthName = DateFormat(DateFormat.ABBR_MONTH).format(weekRange.start);
    final yearString = DateFormat(DateFormat.YEAR).format(weekRange.start);
    final weekOfMonth =
        WeekOfMonth.fromDateTime(weekRange.start).toOrdinalString();
    // 31th week of 2021
    final weekOfYear =
        _intToOrdinalString(Week.fromDate(weekRange.start).weekNumber);

    final weekOfMonthLabel = '$weekOfMonth week of $monthName';
    final weekOfYearLabel = '$weekOfYear week of $yearString';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(weekCost.toLocalString(), style: textTheme.headline5),
        Text(weekOfMonthLabel, style: textTheme.bodyText2),
        Text(weekOfYearLabel, style: textTheme.bodyText2),
      ],
    );
  }

  Widget _footer({required WeekSummary weekSummary}) {
    final categoryCosts = Map.fromEntries(weekSummary.categories
        .map((c) => MapEntry(c, weekSummary.totalCostBy(category: c))));

    return CategoryBreakdown(categoryCosts: categoryCosts);
  }
}

String _intToOrdinalString(int n) {
  final lastDigit = int.parse(n.toString().split('').last);

  late final String suffix;
  switch (lastDigit) {
    case 1:
      suffix = 'st';
      break;
    case 2:
      suffix = 'nd';
      break;
    case 3:
      suffix = 'rd';
      break;
    case 0:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
      suffix = 'th';
      break;
    default:
      throw StateError('Unhandled lastDigit $lastDigit');
  }

  return '$n$suffix';
}
