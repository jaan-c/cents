import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSummaryCard extends StatelessWidget {
  final MonthSummary monthSummary;
  final EdgeInsets margin;

  MonthSummaryCard(
      {required this.monthSummary, this.margin = const EdgeInsets.all(16)});

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

    final monthName =
        DateFormat.MMMM().format(DateTime(2000, monthSummary.month));

    return Text(monthName, style: textTheme.subtitle1);
  }

  Widget _summaryTable(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _categoryTable(context),
        Expanded(
          child: _ExpandedChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _totalsTable(context),
          ),
        ),
      ],
    );
  }

  Widget _categoryTable(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(flex: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      border: TableBorder.symmetric(
          inside: BorderSide(width: 1, color: Colors.grey.withAlpha(60))),
      children: [
        TableRow(
          children: [Text('', style: textTheme.subtitle2)],
        ),
        for (final category in monthSummary.categories)
          TableRow(
            children: [Text(category.name, style: textTheme.subtitle2)],
          ),
        TableRow(
          children: [Text('Total', style: textTheme.subtitle2)],
        )
      ],
    );
  }

  Widget _totalsTable(BuildContext context) {
    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(flex: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      border: TableBorder.symmetric(
          inside: BorderSide(width: 1, color: Colors.grey.withAlpha(60))),
      children: [
        _totalsTableHeader(context),
        for (final category in monthSummary.categories)
          _categoryWeekTotalRow(context, category),
        _weekTotalRow(context),
      ],
    );
  }

  TableRow _totalsTableHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TableRow(
      children: [
        Text('1st', style: textTheme.subtitle2, textAlign: TextAlign.center),
        Text('2nd', style: textTheme.subtitle2, textAlign: TextAlign.center),
        Text('3rd', style: textTheme.subtitle2, textAlign: TextAlign.center),
        Text('4th', style: textTheme.subtitle2, textAlign: TextAlign.center),
        if (monthSummary.has5thWeek)
          Text('5th', style: textTheme.subtitle2, textAlign: TextAlign.center),
        Text('Total', style: textTheme.subtitle2, textAlign: TextAlign.center),
      ],
    );
  }

  TableRow _categoryWeekTotalRow(
      BuildContext context, ExpenseCategory category) {
    final textTheme = Theme.of(context).textTheme;

    final categoryWeekTotals = _weekRange().map(
        (w) => monthSummary.totalCostBy(category: category, weekOfMonth: w));
    final categoryTotal = monthSummary.totalCostBy(category: category);

    return TableRow(
      children: [
        for (final total in categoryWeekTotals)
          Text(
            _amountToStringOrBlank(total),
            style: textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        Text(
          _amountToStringOrBlank(categoryTotal),
          style: textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  TableRow _weekTotalRow(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final weekTotals =
        _weekRange().map((w) => monthSummary.totalCostBy(weekOfMonth: w));
    final grandTotal = monthSummary.totalCostBy();

    return TableRow(
      children: [
        for (final total in weekTotals)
          Text(
            _amountToStringOrBlank(total),
            style: textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        Text(
          _amountToStringOrBlank(grandTotal),
          style: textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Iterable<int> _weekRange() sync* {
    final lastWeek = monthSummary.has5thWeek ? 5 : 4;

    for (var i = 1; i <= lastWeek; i++) {
      yield i;
    }
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
