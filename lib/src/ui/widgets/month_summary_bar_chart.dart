import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

typedef TextToColor = Color Function(Brightness, String);

class MonthSummaryBarChart extends StatelessWidget {
  final MonthSummary monthSummary;
  final TextToColor textToColor;

  MonthSummaryBarChart({required this.monthSummary, required this.textToColor});

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

    final weeks = monthSummary.getAllWeeks();
    final weekCostsAsDouble =
        weeks.map((w) => monthSummary.totalCostBy(weekOfMonth: w).toDouble());
    final maxWeekCostAsDouble = max(weekCostsAsDouble)!;
    final ceilingCostAsDouble =
        math.max(10.0, _ceilingByPlaceValue(maxWeekCostAsDouble));
    final costInterval = ceilingCostAsDouble / 3;

    return BarChartData(
      barGroups: [
        for (final weekOfMonth in weeks)
          _weekToBarData(context, monthSummary, weekOfMonth)
      ],
      // For some reason the top most horizontal line won't render sometimes if
      // verticalInterval * 3 == maxY so make sure maxY will always be bigger.
      maxY: ceilingCostAsDouble + 1,
      groupsSpace: 8,
      alignment: BarChartAlignment.spaceEvenly,
      gridData: _gridData(
        context: context,
        horizontalLineInterval: costInterval,
      ),
      titlesData: _titlesData(
        context: context,
        verticalTitleInterval: costInterval,
      ),
      borderData: _borderData(context: context),
      barTouchData: _barTouchData(context: context),
    );
  }

  BarChartGroupData _weekToBarData(
    BuildContext context,
    MonthSummary monthSummary,
    WeekOfMonth weekOfMonth,
  ) {
    final weekTotalCost = monthSummary.totalCostBy(weekOfMonth: weekOfMonth);

    return BarChartGroupData(
      x: weekOfMonth.toInt(),
      barRods: [
        BarChartRodData(
          y: weekTotalCost.toDouble(),
          width: 32,
          borderRadius: BorderRadius.circular(2),
          rodStackItems:
              _weekToBarStackData(context, monthSummary, weekOfMonth),
        ),
      ],
    );
  }

  List<BarChartRodStackItem> _weekToBarStackData(
    BuildContext context,
    MonthSummary monthSummary,
    WeekOfMonth weekOfMonth,
  ) {
    var acc = Amount();
    final stackData = <BarChartRodStackItem>[];

    // Reverse categories so ascending alphabetical arrangment of categories
    // is preserved since stack is built from bottom up.
    for (final category in monthSummary.getAllCategories().reversed) {
      final weekCategoryCost = monthSummary.totalCostBy(
          weekOfMonth: weekOfMonth, category: category);
      final start = acc;
      final end = start.add(weekCategoryCost);

      final stack = BarChartRodStackItem(
        start.toDouble(),
        end.toDouble(),
        textToColor(Theme.of(context).brightness, category.name),
      );

      acc = end;
      stackData.add(stack);
    }

    return stackData;
  }

  FlGridData _gridData({
    required BuildContext context,
    required double horizontalLineInterval,
  }) {
    final brightness = Theme.of(context).brightness;
    final lineColor =
        brightness == Brightness.light ? Colors.black38 : Colors.white38;

    return FlGridData(
      drawHorizontalLine: true,
      horizontalInterval: horizontalLineInterval,
      getDrawingHorizontalLine: (_) => FlLine(strokeWidth: 1, color: lineColor),
    );
  }

  FlTitlesData _titlesData({
    required BuildContext context,
    required double verticalTitleInterval,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final textStyle = textTheme.bodyText2!.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface);

    return FlTitlesData(
      leftTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(
        showTitles: true,
        interval: verticalTitleInterval,
        reservedSize: 32,
        getTitles: (costAsDouble) =>
            Amount.fromDouble(costAsDouble).toLocalString(compact: true),
        getTextStyles: (_) => textStyle,
      ),
      bottomTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTitles: (weekOfMonth) =>
            WeekOfMonth.fromInt(weekOfMonth.toInt()).toOrdinalString(),
        getTextStyles: (_) => textStyle,
      ),
    );
  }

  FlBorderData _borderData({required BuildContext context}) {
    final brightness = Theme.of(context).brightness;
    final lineColor =
        brightness == Brightness.light ? Colors.black38 : Colors.white38;

    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: lineColor),
      ),
    );
  }

  BarTouchData _barTouchData({required BuildContext context}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final brightness = theme.brightness;

    late final Color backgroundColor;
    late final Color textColor;
    if (brightness == Brightness.light) {
      backgroundColor = Colors.grey[850]!;
      textColor = Colors.white;
    } else {
      backgroundColor = Colors.grey.shade200;
      textColor = Colors.black;
    }

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: backgroundColor,
        tooltipRoundedRadius: 4,
        tooltipPadding: EdgeInsets.all(8),
        getTooltipItem: (_, __, barRod, ___) {
          return BarTooltipItem(
            Amount.fromDouble(barRod.y).toLocalString(),
            textTheme.subtitle2!.copyWith(color: textColor),
          );
        },
        fitInsideHorizontally: false,
        fitInsideVertically: false,
      ),
    );
  }

  double _ceilingByPlaceValue(double n) {
    assert(n >= 0);

    final placeValue = math.min(4, n.toString().length);
    final placeValueFloor = int.parse('1'.padRight(placeValue, '0'));

    return (n / placeValueFloor).ceilToDouble() * placeValueFloor;
  }
}
