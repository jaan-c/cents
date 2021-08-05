import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart' hide DateTimeRange;

import 'month_summary_content.dart';
import 'week_summary_content.dart';

typedef SetDateTimeRangeCallback = void Function(DateTimeRange);

class SummaryCard extends StatelessWidget {
  final DateTimeRange dateTimeRange;
  final List<Expense> expenses;
  final SetDateTimeRangeCallback onSetDateTimeSpan;

  const SummaryCard({
    required this.dateTimeRange,
    required this.expenses,
    required this.onSetDateTimeSpan,
  }) : assert(dateTimeRange is WeekRange || dateTimeRange is MonthRange);

  @override
  Widget build(BuildContext context) {
    if (dateTimeRange is WeekRange) {
      return WeekSummaryContent(
        weekRange: dateTimeRange as WeekRange,
        expenses: expenses,
        onSetWeekRange: onSetDateTimeSpan,
      );
    } else if (dateTimeRange is MonthRange) {
      return MonthSummaryContent(
        monthRange: dateTimeRange as MonthRange,
        expenses: expenses,
        onSetMonthRange: onSetDateTimeSpan,
      );
    } else {
      throw StateError('dateTimeRange must be $WeekRange or $MonthRange');
    }
  }
}
