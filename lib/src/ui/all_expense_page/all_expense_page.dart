import 'package:cents/src/database/amount_range.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:cents/src/ui/widgets/ext_widget_list.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:intl/intl.dart';

import 'all_expense_page_model.dart';
import 'category_name_filter_dialog.dart';
import 'cost_range_filter_dialog.dart';
import 'created_at_range_filter_dialog.dart';
import 'expense_list_tile.dart';
import 'note_keyword_filter_dialog.dart';

class AllExpensePage extends StatefulWidget {
  final AllExpensePageModel model;

  AllExpensePage({required this.model});

  @override
  _AllExpensePageState createState() => _AllExpensePageState(model);
}

class _AllExpensePageState
    extends StateWithModel<AllExpensePage, AllExpensePageModel> {
  @override
  final AllExpensePageModel model;

  _AllExpensePageState(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: _filterBar(
              context: context,
              categoryNameFilter: model.categoryFilter,
              costRangeFilter: model.costRangeFilter,
              createdAtRangeFilter: model.createdAtRangeFilter,
              noteKeywordFilter: model.noteKeywordFilter,
              categories: model.categories,
              setCategoryFilter: model.setCategoryNameFilter,
              setCostRangeFilter: model.setCostRangeFilter,
              setCreatedAtRangeFilter: model.setCreatedAtRangeFilter,
              setNoteKeywordFilter: model.setNoteKeywordFilter,
            ),
          ),
          Expanded(
            child: ListView.separated(
              /// Use ExpenseListTile for display only for now.
              itemBuilder: (_, ix) => ExpenseListTile(
                expense: model.filteredExpenses[ix],
                onTap: () {},
                isSelected: false,
              ),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: model.filteredExpenses.length,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(title: Text('All Expenses'));
  }

  Widget _filterBar({
    required BuildContext context,
    required ExpenseCategory? categoryNameFilter,
    required AmountRange? costRangeFilter,
    required DateTimeRange? createdAtRangeFilter,
    required String? noteKeywordFilter,
    required List<ExpenseCategory> categories,
    required void Function(ExpenseCategory?) setCategoryFilter,
    required void Function(AmountRange?) setCostRangeFilter,
    required void Function(DateTimeRange?) setCreatedAtRangeFilter,
    required void Function(String?) setNoteKeywordFilter,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Filter By'),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _categoryFilterChip(
                  context: context,
                  categoryFilter: categoryNameFilter,
                  categories: categories,
                  setCategoryFilter: setCategoryFilter,
                ),
                _costRangeFilterChip(
                  costRangeFilter: costRangeFilter,
                  setCostRangeFilter: setCostRangeFilter,
                ),
                _createdAtRangeFilterChip(
                  createdAtRangeFilter: createdAtRangeFilter,
                  setCreatedAtRangeFilter: setCreatedAtRangeFilter,
                ),
                _noteKeywordFilterChip(
                  noteKeywordFilter: noteKeywordFilter,
                  setNoteKeywordFilter: setNoteKeywordFilter,
                ),
              ].intersperse(builder: () => SizedBox(width: 8)),
            ),
          ),
        )
      ],
    );
  }

  Widget _categoryFilterChip({
    required BuildContext context,
    required ExpenseCategory? categoryFilter,
    required List<ExpenseCategory> categories,
    required void Function(ExpenseCategory?) setCategoryFilter,
  }) {
    return ActionChip(
      label: Text(categoryFilter != null
          ? 'Category: ${categoryFilter.name}'
          : 'Category'),
      onPressed: () => CategoryFilterDialog.show(
        context: context,
        category: categoryFilter,
        categories: categories,
        onSelectCategory: setCategoryFilter,
      ),
    );
  }

  Widget _costRangeFilterChip({
    required AmountRange? costRangeFilter,
    required void Function(AmountRange?) setCostRangeFilter,
  }) {
    return ActionChip(
      label: Text(
        costRangeFilter != null
            ? 'Cost: ${_amountRangeToString(costRangeFilter)}'
            : 'Cost',
      ),
      onPressed: () => CostRangeFilterDialog.show(
        context: context,
        costRange: costRangeFilter,
        onSetCostRange: setCostRangeFilter,
      ),
    );
  }

  String _amountRangeToString(AmountRange range) {
    if (range.start == range.end) {
      return range.start.toLocalString();
    } else {
      final enDash = '\u2013';
      return '${range.start.toLocalString()}$enDash${range.end.toLocalString()}';
    }
  }

  Widget _createdAtRangeFilterChip({
    required DateTimeRange? createdAtRangeFilter,
    required void Function(DateTimeRange?) setCreatedAtRangeFilter,
  }) {
    return ActionChip(
      label: Text(createdAtRangeFilter != null
          ? 'Date: ${_dateRangeToString(createdAtRangeFilter)}'
          : 'Date'),
      onPressed: () => CreatedAtRangeFilterDialog.show(
        context: context,
        createdAtRange: createdAtRangeFilter,
        onSetCreatedAtRange: setCreatedAtRangeFilter,
      ),
    );
  }

  String _dateRangeToString(DateTimeRange dateTimeRange) {
    final range = DateRange(dateTimeRange.start, dateTimeRange.end);

    if (_isSameDay(range.start, range.end)) {
      return DateFormat.MMMd().format(range.start);
    } else {
      final enDash = '\u2013';
      return '${DateFormat.MMMd().format(range.start)}$enDash${DateFormat.MMMd().format(range.end)}';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _noteKeywordFilterChip({
    required String? noteKeywordFilter,
    required void Function(String?) setNoteKeywordFilter,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 100),
      child: ActionChip(
        label: Text(
          noteKeywordFilter ?? 'Note',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => NoteKeywordFilterDialog.show(
          context: context,
          noteKeyword: noteKeywordFilter,
          onSetNoteKeyword: setNoteKeywordFilter,
        ),
      ),
    );
  }
}
