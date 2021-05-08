import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

typedef TextToColor = Color Function(String);

class MonthSummaryChart extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  MonthSummaryChart({required this.monthSummary, required this.textToColor});

  @override
  Widget build(BuildContext context) {
    return BarChart(_monthToChartData(context, monthSummary));
  }

  BarChartData _monthToChartData(
    BuildContext context,
    MonthSummary monthSummary,
  ) {
    if (monthSummary.isEmpty()) {
      return BarChartData();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final lineColor = colorScheme.onSurface.withAlpha(33);

    final weekOfMonths = monthSummary.getAllWeeks();
    final bars = [
      for (final weekOfMonth in weekOfMonths)
        _weekToBarData(monthSummary, weekOfMonth)
    ];
    final maxWeekCostInUnits = max<int>(
      weekOfMonths.map((w) => monthSummary.totalCostBy(weekOfMonth: w).units),
      (a, b) => a.compareTo(b),
    )!;
    final ceilingCostInUnits =
        math.max(10, _ceilingByPlaceValue(maxWeekCostInUnits));
    final verticalInterval = ceilingCostInUnits / 3;

    return BarChartData(
      // For some reason the top most horizontal line won't render sometimes if
      // verticalInterval * 3 == maxY so make sure maxY will always be bigger.
      maxY: ceilingCostInUnits.toDouble() + 1,
      groupsSpace: 8,
      alignment: BarChartAlignment.spaceEvenly,
      barGroups: bars,
      gridData: FlGridData(
        drawHorizontalLine: true,
        horizontalInterval: verticalInterval,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: lineColor, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(
          showTitles: true,
          interval: verticalInterval,
          getTitles: (cost) =>
              Amount(cost.toInt()).toLocalString(compact: true),
          reservedSize: 32,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitles: (weekOfMonth) => _weekOfMonthToLabel(weekOfMonth.toInt()),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          top: BorderSide(color: lineColor),
          bottom: BorderSide(color: lineColor),
        ),
      ),
      barTouchData: _barTouchData(context: context),
    );
  }

  BarChartGroupData _weekToBarData(
    MonthSummary monthSummary,
    WeekOfMonth weekOfMonth,
  ) {
    final weekTotal = monthSummary.totalCostBy(weekOfMonth: weekOfMonth);
    final categories = monthSummary.getAllCategories();

    var acc = Amount();
    final stackData = <BarChartRodStackItem>[];

    // Reverse categories so ascending alphabetical arrangment of categories
    // is preserved since stack is built from bottom up.
    for (final category in categories.reversed) {
      final weekCategoryCost = monthSummary.totalCostBy(
          weekOfMonth: weekOfMonth, category: category);
      final start = acc;
      final end = start.add(weekCategoryCost);

      final stack = BarChartRodStackItem(
        start.units.toDouble(),
        end.units.toDouble(),
        textToColor(category.name),
      );

      acc = end;
      stackData.add(stack);
    }

    return BarChartGroupData(
      x: weekOfMonth.asInt,
      barRods: [
        BarChartRodData(
          y: weekTotal.units.toDouble(),
          width: 32,
          borderRadius: BorderRadius.circular(2),
          rodStackItems: stackData,
        ),
      ],
    );
  }

  BarTouchData _barTouchData({required BuildContext context}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final brightness = theme.brightness;
    final backgroundColor = brightness == Brightness.light
        ? Colors.grey[850]
        : Colors.grey.shade200;
    final textColor =
        brightness == Brightness.light ? Colors.white : Colors.black;

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: backgroundColor,
        tooltipRoundedRadius: 4,
        tooltipPadding: EdgeInsets.all(8),
        getTooltipItem: (_, __, barRod, ___) {
          return BarTooltipItem(
            Amount(barRod.y.toInt()).toLocalString(),
            textTheme.subtitle2!.copyWith(color: textColor),
          );
        },
        fitInsideHorizontally: false,
        fitInsideVertically: false,
      ),
    );
  }

  String _weekOfMonthToLabel(int weekOfMonth) {
    return WeekOfMonth.fromInt(weekOfMonth).asOrdinal;
  }

  int _ceilingByPlaceValue(int n) {
    assert(n >= 0);

    final placeValue = math.min(4, n.toString().length);
    final placeValueFloor = int.parse('1'.padRight(placeValue, '0'));

    return (n / placeValueFloor).ceil() * placeValueFloor;
  }
}
