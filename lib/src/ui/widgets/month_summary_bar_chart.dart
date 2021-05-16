import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'month_summary_card.dart';
import 'partitioned_bar_chart/partitioned_bar_chart.dart';
import 'partitioned_bar_chart/partitioned_bar_data.dart';

class MonthSummaryBarChart extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  MonthSummaryBarChart({required this.monthSummary, required this.textToColor});

  @override
  Widget build(BuildContext context) {
    final weeks = monthSummary.getAllWeeks();
    final weekCosts = weeks
        .map((w) => monthSummary.totalCostBy(weekOfMonth: w).toDouble())
        .toList();
    final maxWeekCost = max(weekCosts)!;
    final ceilingCost = _ceilingByPlaceValue(maxWeekCost);

    return PartitionedBarChart(
      maxValue: ceilingCost,
      barDatas: _monthSummaryToBarData(
        context: context,
        monthSummary: monthSummary,
        textToColor: textToColor,
      ),
      magnitudePartitionCount: 4,
      magnitudeToLabel: _magnitudeToLabel,
    );
  }

  List<PartitionedBarData> _monthSummaryToBarData({
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
      final categoryCosts = categories.map((c) =>
          monthSummary.totalCostBy(weekOfMonth: week, category: c).toDouble());

      late final List<double> partitionFactors;
      late final List<Color> partitionColors;
      if (value == 0) {
        partitionFactors = [1.0];
        partitionColors = [Colors.blue];
      } else {
        partitionFactors = categoryCosts.map((c) => c / value).toList();
        partitionColors =
            categories.map((c) => textToColor(brightness, c.name)).toList();
      }

      final data = PartitionedBarData(
        value: value,
        label: label,
        partitionFactors: partitionFactors,
        partitionColors: partitionColors,
        tooltipText: '$label Week\n${Amount.fromDouble(value).toLocalString()}',
      );

      barDatas.add(data);
    }

    return barDatas;
  }

  String _magnitudeToLabel(double magnitude) {
    return Amount.fromDouble(magnitude).toLocalString(compact: true);
  }

  double _ceilingByPlaceValue(double n) {
    assert(n >= 0);

    final placeValue = math.min(4, n.toString().length);
    final placeValueFloor = int.parse('1'.padRight(placeValue, '0'));

    return (n / placeValueFloor).ceilToDouble() * placeValueFloor;
  }
}
