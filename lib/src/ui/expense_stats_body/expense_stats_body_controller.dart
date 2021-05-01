import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/foundation.dart' hide Summary;

class ExpenseStatsBodyController with ChangeNotifier {
  final ExpenseProvider provider;

  int? get selectedYear => _selectedYear;

  List<Expense> get allExpenses => _allExpenses;

  Summary get summary => Summary(allExpenses);

  List<int> get allYears => summary.getAllYears().reversed.toList();

  YearSummary? get selectedYearSummary =>
      selectedYear != null ? summary.getYearSummary(selectedYear!) : null;

  int? _selectedYear;
  var _allExpenses = <Expense>[];

  ExpenseStatsBodyController({required this.provider});

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
    _selectedYear = summary.getClosestOldestYear(DateTime.now().year);
    notifyListeners();
  }

  void selectYear(int year) {
    assert(allYears.contains(year));

    _selectedYear = year;
    notifyListeners();
  }
}
