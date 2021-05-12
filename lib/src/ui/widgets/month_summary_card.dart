import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/pair.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/domain/week_of_month.dart';
import 'package:flutter/material.dart';

import 'month_summary_card_content.dart';
import 'week_summary_card_content.dart';

typedef TextToColor = Color Function(Brightness, String);

class MonthSummaryCardMode {
  final WeekOfMonth? _mode;

  MonthSummaryCardMode.week(WeekOfMonth weekOfMonth) : _mode = weekOfMonth;

  MonthSummaryCardMode.month() : _mode = null;

  bool isMonth() {
    return _mode == null;
  }

  WeekOfMonth? toWeek() {
    return _mode;
  }
}

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

  var _selectedMode = MonthSummaryCardMode.month();

  _MonthSummaryCardState({
    required this.monthSummary,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget content;
    if (_selectedMode.isMonth()) {
      content = MonthSummaryCardContent(
        monthSummary: monthSummary,
        textToColor: _textToColor,
      );
    } else {
      final weekOfMonth = _selectedMode.toWeek()!;
      final categories = monthSummary.getAllCategories();
      final costs = categories
          .map((c) =>
              monthSummary.totalCostBy(category: c, weekOfMonth: weekOfMonth))
          .toList();
      final categoryCosts = <Pair<ExpenseCategory, Amount>>[];
      for (var i = 0; i < categories.length; i++) {
        final category = categories[i];
        final cost = costs[i];
        categoryCosts.add(Pair(category, cost));
      }

      content = WeekSummaryCardContent(
        month: monthSummary.month,
        weekOfMonth: weekOfMonth,
        categoryCosts: categoryCosts,
        textToColor: _textToColor,
      );
    }

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
            content,
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
    return PopupMenuButton<MonthSummaryCardMode>(
      itemBuilder: (_) {
        return [
          for (final week in weekOfMonths)
            PopupMenuItem(
              value: MonthSummaryCardMode.week(week),
              child: Text('${week.toOrdinalString()} Week'),
            ),
          PopupMenuItem(
            value: MonthSummaryCardMode.month(),
            child: Text('Month'),
          ),
        ];
      },
      onSelected: onSelectMode,
      child: Chip(
        label: Text(selectedMode.isMonth()
            ? 'Month'
            : '${selectedMode.toWeek()!.toOrdinalString()} Week'),
      ),
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
