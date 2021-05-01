import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/ui/widgets/month_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:cents/src/ui/widgets/ext_widget_list.dart';

import 'expense_stats_body_controller.dart';

const _FAB_SIZE = 56.0;
const _FAB_PADDING = 16;

class ExpenseStatsBody extends StatefulWidget {
  final ExpenseStatsBodyController controller;

  ExpenseStatsBody({required this.controller});

  @override
  _ExpenseStatsBodyState createState() =>
      _ExpenseStatsBodyState(controller: controller);
}

class _ExpenseStatsBodyState extends State<ExpenseStatsBody> {
  final ExpenseStatsBodyController controller;

  _ExpenseStatsBodyState({required this.controller});

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerMutation);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerMutation);
    super.dispose();
  }

  void _onControllerMutation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _yearChoiceChips(
              context: context,
              selectedYear: controller.selectedYear,
              allYears: controller.allYears,
              onSelectYear: controller.selectYear,
            ),
            SizedBox(height: 8),
            if (controller.selectedYearSummary != null)
              _monthSummaryCards(yearSummary: controller.selectedYearSummary!),
            SizedBox(height: _FAB_SIZE + _FAB_PADDING),
          ],
        ),
      ),
    );
  }

  Widget _yearChoiceChips({
    required BuildContext context,
    required int? selectedYear,
    required List<int> allYears,
    required void Function(int) onSelectYear,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final year in allYears)
            _choiceChip(
              context: context,
              selected: year == selectedYear,
              onSelected: () => onSelectYear(year),
              label: Text(year.toString()),
            ),
        ].intersperse(builder: () => SizedBox(width: 8)),
      ),
    );
  }

  Widget _choiceChip({
    required BuildContext context,
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
        for (final monthSummary in yearSummary.getAllMonthSummaries())
          MonthSummaryCard(
            margin: EdgeInsets.zero,
            monthSummary: monthSummary,
          ),
      ].intersperse(builder: () => SizedBox(height: 8)),
    );
  }
}
