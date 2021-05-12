import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/foundation.dart' hide Summary;

typedef OpenEditorCallback = void Function(int expenseId);

class ExpenseListBodyController with ChangeNotifier {
  final ExpenseProvider provider;
  final DateTime currentDate;
  final OpenEditorCallback onOpenEditor;

  List<Expense> get allExpenses => _allExpenses.toList();

  Set<Expense> get expenseSelection => _expenseSelection.toSet();

  MonthSummary? get currentMonthSummary =>
      Summary(allExpenses).getMonthSummary(currentDate.year, currentDate.month);

  var _allExpenses = <Expense>[];
  var _expenseSelection = <Expense>{};

  ExpenseListBodyController(
      {required this.provider,
      required this.onOpenEditor,
      DateTime? currentDate})
      : currentDate = currentDate ?? DateTime.now();

  void initState() {
    provider.addListener(_onProviderMutation);
    _onProviderMutation();
  }

  @override
  void dispose() {
    provider.removeListener(_onProviderMutation);

    super.dispose();
  }

  Future<void> _onProviderMutation() async {
    _allExpenses = await provider.getAllExpenses();
    _expenseSelection = {};

    notifyListeners();
  }

  void toggleExpense(Expense expense) {
    final newSelection = _expenseSelection.toSet();

    if (newSelection.contains(expense)) {
      newSelection.remove(expense);
    } else {
      newSelection.add(expense);
    }

    _expenseSelection = newSelection;
    notifyListeners();
  }

  void clearSelection() {
    _expenseSelection = {};

    notifyListeners();
  }

  Future<void> deleteSelection() async {
    final results = _expenseSelection.map((e) => provider.delete(e.id));
    await Future.wait(results, eagerError: true);

    clearSelection();
  }

  void openEditor(int expenseId) {
    onOpenEditor(expenseId);
  }
}
