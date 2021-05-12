import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/pair.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'month_summary_card.dart';

class WeekSummaryBarChart extends StatelessWidget {
  final List<Pair<ExpenseCategory, Amount>> categoryCosts;
  final TextToColor textToColor;

  WeekSummaryBarChart({
    required this.categoryCosts,
    required this.textToColor,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      _categoryCostsToChartData(
        context: context,
        categoryCosts: categoryCosts,
        textToColor: textToColor,
      ),
    );
  }

  BarChartData _categoryCostsToChartData({
    required BuildContext context,
    required List<Pair<ExpenseCategory, Amount>> categoryCosts,
    required TextToColor textToColor,
  }) {
    if (categoryCosts.isEmpty) {
      return BarChartData();
    }

    final maxCostAsDouble =
        max(categoryCosts.map((pair) => pair.second.toDouble()))!;
    // FIXME: ceilingCostAsDouble becomes 100 instead of 10 on 0 maxCostAsDouble.
    final ceilingCostAsDouble =
        math.max(10, _ceilingByPlaceValue(maxCostAsDouble));
    final costInterval = ceilingCostAsDouble / 3;

    debugPrint('$categoryCosts');
    debugPrint('maxCost: $maxCostAsDouble');
    debugPrint('ceilingCost: $ceilingCostAsDouble');

    return BarChartData(
      maxY: ceilingCostAsDouble + 1,
      alignment: BarChartAlignment.spaceEvenly,
      barGroups: [
        for (final indexedPair in enumerate(categoryCosts))
          _categoryCostToBarData(
            context: context,
            index: indexedPair.index,
            category: indexedPair.value.first,
            cost: indexedPair.value.second,
            textToColor: textToColor,
          ),
      ],
      gridData: _gridData(
        context: context,
        horizontalLineInterval: costInterval,
      ),
      titlesData: _titlesData(
        context: context,
        categoryCosts: categoryCosts,
        verticalTitleInterval: costInterval,
      ),
      borderData: _borderData(context: context),
      barTouchData: _barTouchData(context: context),
    );
  }

  BarChartGroupData _categoryCostToBarData({
    required BuildContext context,
    required int index,
    required ExpenseCategory category,
    required Amount cost,
    required TextToColor textToColor,
  }) {
    final theme = Theme.of(context);

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          y: cost.toDouble(),
          width: 32,
          borderRadius: BorderRadius.circular(2),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              cost.toDouble(),
              textToColor(theme.brightness, category.name),
            ),
          ],
        ),
      ],
    );
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
    required List<Pair<ExpenseCategory, Amount>> categoryCosts,
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
        reservedSize: 32,
        getTitles: (index) => categoryCosts[index.toInt()].first.name,
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

    final ceiled = (n / placeValueFloor).ceilToDouble() * placeValueFloor;
    if (ceiled != n) {
      return ceiled;
    } else {
      return ceiled + placeValueFloor;
    }
  }
}
