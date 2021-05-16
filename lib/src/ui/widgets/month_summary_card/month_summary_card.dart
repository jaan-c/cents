import 'dart:math' as math;
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';

import 'month_summary_card_content.dart';
import 'week_summary_card_content.dart';

typedef TextToColor = Color Function(Brightness, String);

enum MonthSummaryCardMode { week, month }

class MonthSummaryCard extends StatefulWidget {
  final MonthSummary monthSummary;
  final EdgeInsetsGeometry margin;

  MonthSummaryCard({required this.monthSummary, EdgeInsetsGeometry? margin})
      : margin = margin ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  @override
  _MonthSummaryCardState createState() =>
      _MonthSummaryCardState(monthSummary: monthSummary, margin: margin);
}

class _MonthSummaryCardState extends State<MonthSummaryCard> {
  final MonthSummary monthSummary;
  final EdgeInsetsGeometry margin;

  var _selectedMode = MonthSummaryCardMode.week;

  _MonthSummaryCardState({
    required this.monthSummary,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _modeSwitcher(
              selectedMode: _selectedMode,
              onSelectMode: (mode) => setState(() {
                _selectedMode = mode;
              }),
              weekOfMonths: monthSummary.getAllWeeks(),
            ),
            if (_selectedMode == MonthSummaryCardMode.week)
              WeekSummaryCardContent(
                monthSummary: monthSummary,
                textToColor: _textToColor,
              )
            else
              MonthSummaryCardContent(
                monthSummary: monthSummary,
                textToColor: _textToColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _modeSwitcher({
    required MonthSummaryCardMode selectedMode,
    required void Function(MonthSummaryCardMode) onSelectMode,
    required List<WeekOfMonth> weekOfMonths,
  }) {
    late final String label;
    late final VoidCallback onPressed;
    if (_selectedMode == MonthSummaryCardMode.week) {
      label = 'Week Summary';
      onPressed = () => setState(() {
            _selectedMode = MonthSummaryCardMode.month;
          });
    } else {
      label = 'Month Summary';
      onPressed = () => setState(() {
            _selectedMode = MonthSummaryCardMode.week;
          });
    }

    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Color _textToColor(Brightness brightness, String text) {
    final swatches = [
      Colors.pink,
      Colors.red,
      Colors.deepOrange,
      Colors.orange,
      Colors.amber,
      Colors.yellow,
      Colors.lime,
      Colors.lightGreen,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.lightBlue,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
      Colors.blueGrey,
      Colors.brown,
    ];

    final ix = math.Random(text.hashCode).nextInt(swatches.length);
    final swatch = swatches[ix];
    final shade = brightness == Brightness.light ? 400 : 300;

    return swatch[shade]!;
  }
}
