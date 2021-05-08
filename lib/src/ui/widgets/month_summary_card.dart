import 'dart:math' as math;
import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'month_summary_chart.dart';
import 'ext_widget_list.dart';

class MonthSummaryCard extends StatelessWidget {
  final MonthSummary monthSummary;
  final EdgeInsetsGeometry margin;

  MonthSummaryCard({required this.monthSummary, EdgeInsetsGeometry? margin})
      : margin = margin ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context: context, monthSummary: monthSummary),
            SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: MonthSummaryChart(
                monthSummary: monthSummary,
                textToColor: _textToColor,
              ),
            ),
            SizedBox(height: 16),
            _footer(context: context, monthSummary: monthSummary),
          ],
        ),
      ),
    );
  }

  Widget _header({
    required BuildContext context,
    required MonthSummary monthSummary,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final grandTotal = monthSummary.totalCostBy();
    final monthName = DateFormat.MMMM()
        .format(DateTime(monthSummary.year, monthSummary.month));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(grandTotal.toLocalString(), style: textTheme.headline5),
        Text(
          monthName,
          style: textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _footer({
    required BuildContext context,
    required MonthSummary monthSummary,
  }) {
    final categories = monthSummary.getAllCategories();
    final categoryCosts = Map.fromEntries(categories
        .map((c) => MapEntry(c, monthSummary.totalCostBy(category: c))));

    return _FixedGrid(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final category in categories)
          _footerTile(
            context: context,
            category: category,
            cost: categoryCosts[category]!,
          )
      ],
    );
  }

  Widget _footerTile({
    required BuildContext context,
    required ExpenseCategory category,
    required Amount cost,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          color: _textToColor(theme.brightness, category.name),
          size: 12,
        ),
        SizedBox(width: 8),
        DefaultTextStyle(
          style: textTheme.bodyText2!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name),
              Text(cost.toLocalString()),
            ],
          ),
        ),
      ],
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

class _FixedGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Widget> children;

  _FixedGrid({
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.children = const [],
  }) : assert(crossAxisCount >= 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final rowChildren in _groupByCount(children, crossAxisCount))
          _row(children: rowChildren),
      ].intersperse(builder: () => SizedBox(height: mainAxisSpacing)),
    );
  }

  Widget _row({required List<Widget> children}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.intersperse(
          builder: () => SizedBox(width: crossAxisSpacing)),
    );
  }
}

List<List<T>> _groupByCount<T>(List<T> items, int count) {
  assert(count >= 1);

  final acc = <List<T>>[];
  var remaining = items;

  while (remaining.isNotEmpty) {
    final head = remaining.take(count).toList();
    final tail = remaining.skip(count).toList();

    acc.add(head);
    remaining = tail;
  }

  return acc;
}
