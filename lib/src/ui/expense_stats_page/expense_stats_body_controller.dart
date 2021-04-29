import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/foundation.dart' hide Summary;

class ExpenseStatsBodyController with ChangeNotifier {
  final ExpenseProvider provider;

  int get selectedYear => _selectedYear;

  List<Expense> get allExpenses => _allExpenses;

  Summary get summary => Summary(allExpenses);

  YearSummary? get selectedYearSummary => summary.getYearSummary(selectedYear);

  bool get hasPreviousYear => summary.hasYear(selectedYear - 1);

  bool get hasNextYear => summary.hasYear(selectedYear + 1);

  int _selectedYear;
  var _allExpenses = <Expense>[];

  ExpenseStatsBodyController({required this.provider, int? selectedYear})
      : _selectedYear = selectedYear ?? DateTime.now().year;

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
    notifyListeners();
  }

  void selectPreviousYear() {
    assert(hasPreviousYear);

    _selectedYear--;
    notifyListeners();
  }

  void selectNextYear() {
    assert(hasNextYear);

    _selectedYear++;
    notifyListeners();
  }
}
