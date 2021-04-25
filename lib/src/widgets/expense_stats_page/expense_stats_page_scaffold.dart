import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/widgets/shared/month_summary_card.dart';
import 'package:flutter/material.dart';

class ExpenseStatsPageScaffold extends StatelessWidget {
  final YearSummary? yearSummary;
  final VoidCallback? onPreviousYear;
  final VoidCallback? onNextYear;

  ExpenseStatsPageScaffold(
      {this.yearSummary, this.onPreviousYear, this.onNextYear});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: yearSummary != null ? _monthSummaryCards() : null,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        yearSummary != null ? '${yearSummary!.year} Summary' : 'No Expenses',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.navigate_before_rounded),
          onPressed: onPreviousYear,
        ),
        IconButton(
          icon: Icon(Icons.navigate_next_rounded),
          onPressed: onNextYear,
        ),
      ],
    );
  }

  Widget _monthSummaryCards() {
    final months = yearSummary!.monthSummaries.keys.toList()..sort();

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, ix) {
        final month = months[ix];
        final monthSummary = yearSummary!.monthSummaries[month]!;

        return MonthSummaryCard(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          monthSummary: monthSummary,
        );
      },
    );
  }
}
