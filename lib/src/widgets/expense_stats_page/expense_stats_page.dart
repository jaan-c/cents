import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expense_stats_page_scaffold.dart';

class ExpenseStatsPage extends StatefulWidget {
  @override
  _ExpenseStatsPageState createState() => _ExpenseStatsPageState();
}

class _ExpenseStatsPageState extends State<ExpenseStatsPage> {
  late ExpenseProvider provider;
  var selectedYear = DateTime.now().year;
  var allExpenses = <Expense>[];

  Summary get summary => Summary(allExpenses);

  bool get hasPreviousYear =>
      summary.yearSummaries.containsKey(selectedYear - 1);
  bool get hasNextYear => summary.yearSummaries.containsKey(selectedYear + 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      provider = context.read<ExpenseProvider>();
      _onProviderMutation();
      provider.addListener(_onProviderMutation);
    });
  }

  @override
  void dispose() {
    provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _onProviderMutation() async {
    final newAllExpenses = await provider.getAllExpenses();
    setState(() {
      allExpenses = newAllExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpenseStatsPageScaffold(
      yearSummary: summary.yearSummaries[selectedYear],
      onPreviousYear: hasPreviousYear ? _selectPreviousYear : null,
      onNextYear: hasNextYear ? _selectNextYear : null,
    );
  }

  void _selectPreviousYear() {
    assert(hasPreviousYear);

    setState(() {
      selectedYear--;
    });
  }

  void _selectNextYear() {
    assert(hasNextYear);

    setState(() {
      selectedYear++;
    });
  }
}
