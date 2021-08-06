import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:flutter/material.dart' hide DateTimeRange;

import 'month_summary_content.dart';
import 'week_summary_content.dart';

class SummaryCard extends StatelessWidget {
  final SummaryCardData data;

  const SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data is WeekSummaryCardData) {
      return WeekSummaryContent(
        weekRange: data.dateTimeRange as WeekRange,
        expenses: data.expenses,
        onSetWeekRange: data.onSetDateTimeRange,
      );
    } else if (data is MonthSummaryCardData) {
      return MonthSummaryContent(
        monthRange: data.dateTimeRange as MonthRange,
        expenses: data.expenses,
        onSetMonthRange: data.onSetDateTimeRange,
      );
    } else {
      throw StateError('dateTimeRange must be $WeekRange or $MonthRange');
    }
  }
}

typedef SetDateTimeRangeCallback<T extends DateTimeRange> = void Function(T);

abstract class SummaryCardData<T extends DateTimeRange> {
  abstract final T dateTimeRange;
  abstract final List<Expense> expenses;
  abstract final SetDateTimeRangeCallback<T> onSetDateTimeRange;
}

class WeekSummaryCardData implements SummaryCardData<WeekRange> {
  @override
  final WeekRange dateTimeRange;
  @override
  final List<Expense> expenses;
  @override
  final SetDateTimeRangeCallback<WeekRange> onSetDateTimeRange;

  WeekSummaryCardData({
    required this.dateTimeRange,
    required this.expenses,
    required this.onSetDateTimeRange,
  });
}

class MonthSummaryCardData implements SummaryCardData<MonthRange> {
  @override
  final MonthRange dateTimeRange;
  @override
  final List<Expense> expenses;
  @override
  final SetDateTimeRangeCallback<MonthRange> onSetDateTimeRange;

  MonthSummaryCardData({
    required this.dateTimeRange,
    required this.expenses,
    required this.onSetDateTimeRange,
  });
}
