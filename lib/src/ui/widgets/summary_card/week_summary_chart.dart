import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/week_summary.dart';
import 'package:cents/src/ui/widgets/partitioned_bar_chart/partitioned_bar_chart.dart';
import 'package:cents/src/ui/widgets/partitioned_bar_chart/partitioned_bar_data.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:cents/src/domain/ext_double.dart';

class WeekSummaryChart extends StatelessWidget {
  static const _weekdays = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  final WeekSummary weekSummary;

  const WeekSummaryChart({required this.weekSummary});

  @override
  Widget build(BuildContext context) {
    final weekdayCosts =
        _weekdays.map((w) => weekSummary.totalCostBy(weekday: w).toDouble());
    final maxWeekdayCost = max(weekdayCosts)!;
    final ceilingWeekdayCost = maxWeekdayCost.ceilingByPlaceValue();

    return PartitionedBarChart(
      maxValue: ceilingWeekdayCost,
      barDatas: _barDatas(weekSummary: weekSummary),
      magnitudePartitionCount: 4,
      magnitudeToLabel: (m) =>
          Amount.fromDouble(m).toLocalString(compact: true),
    );
  }

  List<PartitionedBarData> _barDatas({required WeekSummary weekSummary}) {
    final weekdayCosts = _weekdays
        .map((w) => weekSummary.totalCostBy(weekday: w).toDouble())
        .toList();
    final categories = weekSummary.categories;

    final barDatas = <PartitionedBarData>[];

    for (var i = 0; i < _weekdays.length; i++) {
      final weekday = _weekdays[i];
      final weekdayValue = weekdayCosts[i];

      final label = _weekdayToLabel(weekday);
      final categoryCosts = categories
          .map((c) =>
              weekSummary.totalCostBy(weekday: weekday, category: c).toDouble())
          .toList();

      final data = PartitionedBarData(
          label: label,
          partitionValues: categoryCosts,
          partitionColors: categories.map((c) => c.color).toList(),
          tooltipText:
              '$label ${Amount.fromDouble(weekdayValue).toLocalString()}');

      barDatas.add(data);
    }

    return barDatas;
  }

  String _weekdayToLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        throw StateError('Invalid weekday $weekday');
    }
  }
}
