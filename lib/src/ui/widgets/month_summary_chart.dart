import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'month_summary_card.dart';
import 'partitioned_bar_chart/partitioned_bar_chart.dart';
import 'partitioned_bar_chart/partitioned_bar_data.dart';

class MonthSummaryChart extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  MonthSummaryChart({required this.monthSummary, required this.textToColor});

  @override
  Widget build(BuildContext context) {
    final weeks = monthSummary.getAllWeeks();
    final weekCosts =
        weeks.map((w) => monthSummary.totalCostBy(weekOfMonth: w).toDouble());
    final maxWeekCost = max(weekCosts)!;
    final ceilingCost = _ceilingByPlaceValue(maxWeekCost);

    return PartitionedBarChart(
      maxValue: ceilingCost,
      barDatas: _barDatas(
        context: context,
        monthSummary: monthSummary,
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
    required TextToColor textToColor,
  }) {
    final brightness = Theme.of(context).brightness;

    final weeks = monthSummary.getAllWeeks();
    final weekCosts = weeks
        .map((w) => monthSummary.totalCostBy(weekOfMonth: w).toDouble())
        .toList();
    final categories = monthSummary.getAllCategories();

    final barDatas = <PartitionedBarData>[];

    for (var i = 0; i < weeks.length; i++) {
      final week = weeks[i];
      final value = weekCosts[i];

      final label = week.toOrdinalString();
      final categoryCosts = categories
          .map((c) => monthSummary
              .totalCostBy(weekOfMonth: week, category: c)
              .toDouble())
          .toList();

      final data = PartitionedBarData(
        value: value,
        label: label,
        partitionValues: categoryCosts,
        partitionColors:
            categories.map((c) => textToColor(brightness, c.name)).toList(),
        tooltipText: '$label Week\n${Amount.fromDouble(value).toLocalString()}',
      );

      barDatas.add(data);
    }

    return barDatas;
  }

  double _ceilingByPlaceValue(double n) {
    assert(n >= 0);

    final placeValue = math.min(4, n.toString().length);
    final placeValueFloor = int.parse('1'.padRight(placeValue, '0'));

    return (n / placeValueFloor).ceilToDouble() * placeValueFloor;
  }
}
