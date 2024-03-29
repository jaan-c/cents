import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:cents/src/domain/ext_double.dart';
import 'package:cents/src/ui/widgets/partitioned_bar_chart/partitioned_bar_chart.dart';
import 'package:cents/src/ui/widgets/partitioned_bar_chart/partitioned_bar_data.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'month_summary_card.dart';

class WeekSummaryChart extends StatelessWidget {
  static const _dayOfWeeks = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  final MonthSummary monthSummary;
  final WeekOfMonth weekOfMonth;
  final TextToColor textToColor;

  const WeekSummaryChart({super.key, 
    required this.monthSummary,
    required this.weekOfMonth,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    final weekCosts = _dayOfWeeks.map((d) => monthSummary
        .totalCostBy(weekOfMonth: weekOfMonth, dayOfWeek: d)
        .toDouble());
    final maxWeekCost = max(weekCosts)!;
    final ceilingCost = maxWeekCost.ceilingByPlaceValue();

    return PartitionedBarChart(
      maxValue: ceilingCost,
      barDatas: _barDatas(
        context: context,
        monthSummary: monthSummary,
        weekOfMonth: weekOfMonth,
        textToColor: textToColor,
      ),
      magnitudePartitionCount: 4,
      magnitudeToLabel: (m) =>
          Amount.fromDouble(m).toLocalString(compact: true),
    );
  }

  List<PartitionedBarData> _barDatas({
    required BuildContext context,
    required MonthSummary monthSummary,
    required WeekOfMonth weekOfMonth,
    required TextToColor textToColor,
  }) {
    final brightness = Theme.of(context).brightness;

    final dayOfWeekCosts = _dayOfWeeks
        .map((d) => monthSummary
            .totalCostBy(weekOfMonth: weekOfMonth, dayOfWeek: d)
            .toDouble())
        .toList();
    final categories = monthSummary.categories;

    final barDatas = <PartitionedBarData>[];

    for (var i = 0; i < _dayOfWeeks.length; i++) {
      final dayOfWeek = _dayOfWeeks[i];
      final cost = dayOfWeekCosts[i];

      final label = _intToDayOfWeekAbbreviation(dayOfWeek);
      final costs = categories
          .map((c) => monthSummary
              .totalCostBy(
                  weekOfMonth: weekOfMonth, dayOfWeek: dayOfWeek, category: c)
              .toDouble())
          .toList();

      final data = PartitionedBarData(
        value: cost,
        label: label,
        partitionValues: costs,
        partitionColors:
            categories.map((c) => textToColor(brightness, c.name)).toList(),
        tooltipText: '$label\n${Amount.fromDouble(cost).toLocalString()}',
      );

      barDatas.add(data);
    }

    return barDatas;
  }

  String _intToDayOfWeekAbbreviation(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        throw StateError('Invalid day of week $dayOfWeek.');
    }
  }
}
