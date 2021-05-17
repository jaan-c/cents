import 'dart:math' as math;
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';

import 'month_summary_card_content.dart';
import 'week_summary_card_content.dart';

typedef TextToColor = Color Function(Brightness, String);

enum MonthSummaryCardMode { month, week }

class MonthSummaryCard extends StatefulWidget {
  final MonthSummary monthSummary;
  final MonthSummaryCardMode mode;
  final EdgeInsetsGeometry margin;

  MonthSummaryCard({
    required this.monthSummary,
    this.mode = MonthSummaryCardMode.month,
    EdgeInsetsGeometry? margin,
  }) : margin = margin ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  @override
  _MonthSummaryCardState createState() => _MonthSummaryCardState(
      monthSummary: monthSummary, mode: mode, margin: margin);
}

class _MonthSummaryCardState extends State<MonthSummaryCard> {
  MonthSummary monthSummary;
  EdgeInsetsGeometry margin;
  MonthSummaryCardMode selectedMode;

  _MonthSummaryCardState({
    required this.monthSummary,
    required MonthSummaryCardMode mode,
    required this.margin,
  }) : selectedMode = mode;

  @override
  void didUpdateWidget(covariant MonthSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      monthSummary = widget.monthSummary;
      margin = widget.margin;
      selectedMode = widget.mode;
    });
  }

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
              selectedMode: selectedMode,
              onSelectMode: (mode) => setState(() {
                selectedMode = mode;
              }),
              weekOfMonths: monthSummary.getAllWeeks(),
            ),
            if (selectedMode == MonthSummaryCardMode.week)
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
    if (selectedMode == MonthSummaryCardMode.month) {
      label = 'Month Summary';
      onPressed = () => setState(() {
            selectedMode = MonthSummaryCardMode.week;
          });
    } else {
      label = 'Week Summary';
      onPressed = () => setState(() {
            selectedMode = MonthSummaryCardMode.month;
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
