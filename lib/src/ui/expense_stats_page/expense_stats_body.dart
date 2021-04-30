import 'package:cents/src/ui/widgets/month_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:cents/src/ui/widgets/ext_widget_list.dart';

import 'expense_stats_body_controller.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: _yearChoiceChips(
            context: context,
            selectedYear: controller.selectedYear,
            allYears: controller.allYears,
            onSelectYear: controller.selectYear,
          ),
        ),
        if (controller.selectedYearSummary != null)
          Expanded(
            child: _monthSummaryCards(
              eachMargin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
      ],
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
        (selected ? chipTheme.secondaryLabelStyle : chipTheme.labelStyle)
            .copyWith(fontWeight: FontWeight.bold);

    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: labelStyle,
      label: label,
    );
  }

  Widget _monthSummaryCards({EdgeInsetsGeometry? eachMargin}) {
    final yearSummary = controller.selectedYearSummary!;
    final months = yearSummary.getAllMonths();

    return ListView.builder(
      itemCount: months.length,
      itemBuilder: (context, ix) {
        final month = months[ix];
        final monthSummary = yearSummary.getMonthSummary(month)!;

        return MonthSummaryCard(
          margin: eachMargin,
          monthSummary: monthSummary,
        );
      },
    );
  }
}
