import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/ui/expense_editor_page/expense_editor_page.dart';
import 'package:cents/src/ui/expense_editor_page/expense_editor_page_model.dart';
import 'package:cents/src/ui/expense_stats_page/expense_stats_page.dart';
import 'package:cents/src/ui/expense_stats_page/expense_stats_page_model.dart';
import 'package:cents/src/ui/settings_page/settings_page.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OpenEditorCallback = void Function(int expenseId);

class ExpenseListPageModel extends StateModel {
  final ExpenseProvider provider;
  final DateTime currentDateTime;

  var _expenses = <Expense>[];
  List<Expense> get expenses => _expenses.toList();

  var _selectedExpenses = <Expense>{};
  Set<Expense> get selectedExpenses => _selectedExpenses.toSet();
  bool get hasSelectedExpense => selectedExpenses.isNotEmpty;

  MonthSummary get currentMonthSummary => Summary(_expenses)
      .getMonthSummary(currentDateTime.year, currentDateTime.month);

  ExpenseListPageModel({
    required this.provider,
    DateTime? currentDateTime,
  }) : currentDateTime = currentDateTime ?? DateTime.now();

  @override
  void initState() {
    super.initState();

    provider.addListener(_updateStateFromProvider);

    _updateStateFromProvider();
  }

  @override
  void dispose() {
    provider.removeListener(_updateStateFromProvider);

    super.dispose();
  }

  Future<void> _updateStateFromProvider() async {
    final expenses = await provider.getAllExpenses();

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
    final expenseIds = selectedExpenses.map((e) => e.id).toList();
    await provider.deleteAll(expenseIds);

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

  Future<void> navigateToStats(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ExpenseStatsPage(
          model: ExpenseStatsPageModel(
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
