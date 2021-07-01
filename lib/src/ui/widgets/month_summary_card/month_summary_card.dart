import 'dart:math' as math;
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:cents/src/domain/ext_date_time.dart';
import 'package:flutter/material.dart';

import 'month_summary_card_content.dart';
import 'week_summary_card_content.dart';

typedef TextToColor = Color Function(Brightness, String);

enum MonthSummaryCardMode { month, week }

class MonthSummaryCard extends StatefulWidget {
  final MonthSummary monthSummary;
  final MonthSummaryCardMode mode;
  final WeekOfMonth weekOfMonth;
  final EdgeInsetsGeometry margin;

  MonthSummaryCard._internal({
    required this.monthSummary,
    required this.mode,
    required this.weekOfMonth,
    required this.margin,
  });

  factory MonthSummaryCard({
    required MonthSummary monthSummary,
    MonthSummaryCardMode mode = MonthSummaryCardMode.month,
    WeekOfMonth? weekOfMonth,
    EdgeInsetsGeometry margin =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  }) {
    final now = DateTime.now();
    if (weekOfMonth == null &&
        monthSummary.year == now.year &&
        monthSummary.month == now.month) {
      weekOfMonth = now.weekOfMonth;
    }

    weekOfMonth ??= WeekOfMonth.first;

    return MonthSummaryCard._internal(
      monthSummary: monthSummary,
      mode: mode,
      weekOfMonth: weekOfMonth,
      margin: margin,
    );
  }

  @override
  _MonthSummaryCardState createState() =>
      _MonthSummaryCardState(mode: mode, weekOfMonth: weekOfMonth);
}

class _MonthSummaryCardState extends State<MonthSummaryCard> {
  MonthSummary get monthSummary => widget.monthSummary;
  EdgeInsetsGeometry get margin => widget.margin;

  MonthSummaryCardMode _mode;
  WeekOfMonth _weekOfMonth;

  _MonthSummaryCardState({
    required MonthSummaryCardMode mode,
    required WeekOfMonth weekOfMonth,
  })  : _mode = mode,
        _weekOfMonth = weekOfMonth;

  @override
  void didUpdateWidget(covariant MonthSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.monthSummary != oldWidget.monthSummary) {
      final weeks = widget.monthSummary.weeks;

      if (_weekOfMonth.toInt() > weeks.last.toInt()) {
        _weekOfMonth = weeks.last;
      }
    }
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
              mode: _mode,
              onSelectMode: (m) => setState(() {
                _mode = m;
              }),
              weekOfMonths: monthSummary.weeks,
            ),
            if (_mode == MonthSummaryCardMode.week)
              WeekSummaryCardContent(
                monthSummary: monthSummary,
                weekOfMonth: _weekOfMonth,
                onChangeWeekOfMonth: (w) => setState(() {
                  _weekOfMonth = w;
                }),
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
    required MonthSummaryCardMode mode,
    required void Function(MonthSummaryCardMode) onSelectMode,
    required List<WeekOfMonth> weekOfMonths,
  }) {
    late final String label;
    late final VoidCallback onPressed;
    if (mode == MonthSummaryCardMode.month) {
      label = 'Month Summary';
      onPressed = () => onSelectMode(MonthSummaryCardMode.week);
    } else {
      label = 'Week Summary';
      onPressed = () => onSelectMode(MonthSummaryCardMode.month);
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
