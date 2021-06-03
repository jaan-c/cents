import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/ui/widgets/month_summary_card/month_summary_card.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';
import 'package:cents/src/ui/widgets/ext_widget_list.dart';

import 'expense_stats_page_model.dart';

class ExpenseStatsPage extends StatefulWidget {
  final ExpenseStatsPageModel model;

  ExpenseStatsPage({required this.model});

  @override
  _ExpenseStatsPageState createState() => _ExpenseStatsPageState(model);
}

class _ExpenseStatsPageState
    extends StateWithModel<ExpenseStatsPage, ExpenseStatsPageModel> {
  @override
  final ExpenseStatsPageModel model;

  _ExpenseStatsPageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: SingleChildScrollView(
        primary: true,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _yearChoiceChips(
                context: context,
                years: model.years,
                selectedYear: model.selectedYear,
                onSelectYear: model.selectYear,
              ),
              SizedBox(height: 8),
              if (model.selectedYearSummary.isNotEmpty)
                _monthSummaryCards(yearSummary: model.selectedYearSummary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yearChoiceChips({
    required BuildContext context,
    required List<int> years,
    required int? selectedYear,
    required void Function(int) onSelectYear,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final year in years)
            _choiceChip(
              selected: year == selectedYear,
              onSelected: () => onSelectYear(year),
              label: Text(year.toString()),
            ),
        ].intersperse(builder: () => SizedBox(width: 8)),
      ),
    );
  }

  Widget _choiceChip({
    required bool selected,
    required VoidCallback onSelected,
    required Widget label,
  }) {
    final chipTheme = ChipTheme.of(context);
    final labelStyle =
        (!selected ? chipTheme.labelStyle : chipTheme.secondaryLabelStyle)
            .copyWith(fontWeight: FontWeight.w500);

    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: labelStyle,
      label: label,
    );
  }

  Widget _monthSummaryCards({required YearSummary yearSummary}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final monthSummary in yearSummary.monthSummaries)
          MonthSummaryCard(
            margin: EdgeInsets.zero,
            monthSummary: monthSummary,
          ),
      ].intersperse(builder: () => SizedBox(height: 8)),
    );
  }
}
