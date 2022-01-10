import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/ui/all_expense_page/all_expense_page.dart';
import 'package:cents/src/ui/all_expense_page/all_expense_page_model.dart';
import 'package:cents/src/ui/category_list_page/category_list_page.dart';
import 'package:cents/src/ui/category_list_page/category_list_page_model.dart';
import 'package:cents/src/ui/expense_editor_page/expense_editor_page.dart';
import 'package:cents/src/ui/expense_editor_page/expense_editor_page_model.dart';
import 'package:cents/src/ui/settings_page/settings_page.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:provider/provider.dart';
import 'package:cents/src/domain/week_range.dart';

typedef OpenEditorCallback = void Function(int expenseId);

enum SummaryCardMode { week, month }

class ExpenseListPageModel extends StateModel {
  final ExpenseProvider provider;
  final DateTime currentDateTime;

  var _summaryCardMode = SummaryCardMode.week;
  SummaryCardMode get summaryCardMode => _summaryCardMode;

  WeekRange _weekRange;
  WeekRange get weekRange => _weekRange;

  MonthRange _monthRange;
  MonthRange get monthRange => _monthRange;

  var _expenses = <Expense>[];
  List<Expense> get expenses => _expenses.toList();

  var _selectedExpenses = <Expense>{};
  Set<Expense> get selectedExpenses => _selectedExpenses.toSet();
  bool get hasSelectedExpense => selectedExpenses.isNotEmpty;

  ExpenseListPageModel._internal(
    this.provider,
    this.currentDateTime,
    this._weekRange,
    this._monthRange,
  );

  factory ExpenseListPageModel({
    required ExpenseProvider provider,
    DateTime? currentDateTime,
  }) {
    currentDateTime ??= DateTime.now();

    final weekRange = WeekRange.fromDateTime(currentDateTime);
    final monthRange = MonthRange(currentDateTime.year, currentDateTime.month);

    return ExpenseListPageModel._internal(
        provider, currentDateTime, weekRange, monthRange);
  }

  @override
  void initState() {
    super.initState();

    provider.addListener(_updateExpensesFilteredByDateTimeRange);

    _updateExpensesFilteredByDateTimeRange();
  }

  @override
  void dispose() {
    provider.removeListener(_updateExpensesFilteredByDateTimeRange);

    super.dispose();
  }

  Future<void> switchSummaryCardMode() async {
    _summaryCardMode = summaryCardMode == SummaryCardMode.week
        ? SummaryCardMode.month
        : SummaryCardMode.week;
    _expenses = [];
    clearSelectedExpenses();
    notifyListeners();

    await _updateExpensesFilteredByDateTimeRange();
  }

  Future<void> setWeekRange(WeekRange newWeekRange) async {
    _weekRange = newWeekRange;
    _expenses = [];
    clearSelectedExpenses();
    notifyListeners();

    await _updateExpensesFilteredByDateTimeRange();
  }

  Future<void> setMonthRange(MonthRange newMonthRange) async {
    _monthRange = newMonthRange;
    _expenses = [];
    clearSelectedExpenses();
    notifyListeners();

    await _updateExpensesFilteredByDateTimeRange();
  }

  Future<void> _updateExpensesFilteredByDateTimeRange() async {
    final dateTimeRange =
        summaryCardMode == SummaryCardMode.week ? weekRange : monthRange;
    final expenses = await provider.getExpenseBy(createdAtRange: dateTimeRange);

    _expenses = expenses;
    clearSelectedExpenses();
    notifyListeners();
  }

  void toggleSelectExpense(Expense expense) {
    assert(expenses.contains(expense));

    final copy = selectedExpenses.toSet();
    if (selectedExpenses.contains(expense)) {
      copy.remove(expense);
    } else {
      copy.add(expense);
    }

    _selectedExpenses = copy;
    notifyListeners();
  }

  void clearSelectedExpenses() {
    _selectedExpenses = {};
    notifyListeners();
  }

  Future<void> deleteSelectedExpenses() async {
    final expenseIds = selectedExpenses.map((e) => e.id);
    await provider.deleteAllExpenses(expenseIds);

    notifyListeners();
  }

  Future<void> navigateToEditor(
    BuildContext context, [
    int expenseId = Expense.UNSET_ID,
  ]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ExpenseEditorPage(
          model: ExpenseEditorPageModel(
            provider: context.read<ExpenseProvider>(),
            id: expenseId,
          ),
        );
      }),
    );
  }

  Future<void> navigateToAllExpenses(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AllExpensePage(
            model: AllExpensePageModel(
              provider: context.read<ExpenseProvider>(),
            ),
          );
        },
      ),
    );
  }

  Future<void> navigateToCategories(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CategoryListPage(
          model: CategoryListPageModel(
            provider: context.read<ExpenseProvider>(),
          ),
        );
      }),
    );
  }

  Future<void> navigateToSettings(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return SettingsPage(provider: context.read<ExpenseProvider>());
      }),
    );
  }
}
