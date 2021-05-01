import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context),
            SizedBox(height: 8),
            _summaryTable(context),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final monthName = DateFormat.MMMM()
        .format(DateTime(monthSummary.year, monthSummary.month));

    return Text(monthName, style: textTheme.headline5);
  }

  Widget _summaryTable(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _categoryColumn(context),
        Expanded(
          child: _ExpandedChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _totalsTable(context),
          ),
        ),
      ],
    );
  }

  Widget _categoryColumn(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return DefaultTextStyle(
      style: textTheme.subtitle2!,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
      child: Table(
        defaultColumnWidth: IntrinsicColumnWidth(flex: 1),
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        border: TableBorder(
            horizontalInside: BorderSide(
                width: 1, color: colorScheme.onSurface.withAlpha(33))),
        children: [
          TableRow(
            children: [
              Text(''),
            ]
                .padEach(padding: EdgeInsets.all(8))
                .constrainEach(constraints: BoxConstraints(maxWidth: 80)),
          ),
          for (final category in monthSummary.getAllCategories())
            TableRow(
              children: [
                Text(category.name),
              ]
                  .padEach(padding: EdgeInsets.all(8))
                  .constrainEach(constraints: BoxConstraints(maxWidth: 80)),
            ),
          TableRow(
            children: [
              Text('Total'),
            ]
                .padEach(padding: EdgeInsets.all(8))
                .constrainEach(constraints: BoxConstraints(maxWidth: 80)),
          )
        ],
      ),
    );
  }

  Widget _totalsTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return DefaultTextStyle(
      style: textTheme.bodyText2!,
      textAlign: TextAlign.center,
      child: Table(
        defaultColumnWidth: IntrinsicColumnWidth(flex: 1),
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        border: TableBorder(
            horizontalInside: BorderSide(
                width: 1, color: colorScheme.onSurface.withAlpha(33))),
        children: [
          _totalsTableHeader(context),
          for (final category in monthSummary.getAllCategories())
            _categoryWeekTotalRow(category),
          _weekTotalRow(),
        ],
      ),
    );
  }

  TableRow _totalsTableHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TableRow(
      children: [
        for (final week in monthSummary.getAllWeeks())
          Text(week.asOrdinal, style: textTheme.subtitle2),
        Text('Total', style: textTheme.subtitle2),
      ]
          .padEach(padding: EdgeInsets.all(8))
          .constrainEach(constraints: BoxConstraints(minWidth: 60)),
    );
  }

  TableRow _categoryWeekTotalRow(ExpenseCategory category) {
    final categoryWeekTotals = monthSummary.getAllWeeks().map(
        (w) => monthSummary.totalCostBy(category: category, weekOfMonth: w));
    final categoryTotal = monthSummary.totalCostBy(category: category);

    return TableRow(
      children: [
        for (final total in categoryWeekTotals)
          Text(_amountToStringOrBlank(total)),
        Text(_amountToStringOrBlank(categoryTotal)),
      ]
          .padEach(padding: EdgeInsets.all(8))
          .constrainEach(constraints: BoxConstraints(minWidth: 60)),
    );
  }

  TableRow _weekTotalRow() {
    final weekTotals = monthSummary
        .getAllWeeks()
        .map((w) => monthSummary.totalCostBy(weekOfMonth: w));
    final grandTotal = monthSummary.totalCostBy();

    return TableRow(
      children: [
        for (final total in weekTotals) Text(_amountToStringOrBlank(total)),
        Text(_amountToStringOrBlank(grandTotal)),
      ]
          .padEach(padding: EdgeInsets.all(8))
          .constrainEach(constraints: BoxConstraints(minWidth: 60)),
    );
  }

  String _amountToStringOrBlank(Amount amount) {
    return amount != Amount() ? '\u20B1${amount.toString()}' : '';
  }
}

/// A container for a scrollable [child] that is forced to take up the entire
/// [scrollDirection] [Axis] if smaller.
class _ExpandedChildScrollView extends StatelessWidget {
  final Axis scrollDirection;
  final Widget child;

  _ExpandedChildScrollView(
      {required this.scrollDirection, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: scrollDirection,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: scrollDirection == Axis.horizontal
                    ? constraints.maxWidth
                    : 0,
                minHeight: scrollDirection == Axis.vertical
                    ? constraints.maxHeight
                    : 0),
            child: child,
          ),
        );
      },
    );
  }
}
