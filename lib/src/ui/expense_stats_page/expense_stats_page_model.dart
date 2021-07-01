import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/summary.dart';
import 'package:cents/src/ui/widgets/state_model.dart';
import 'package:quiver/iterables.dart';

class ExpenseStatsPageModel extends StateModel {
  final ExpenseProvider provider;

  var _expenses = <Expense>[];
  List<Expense> get expenses => _expenses.toList();

  var _selectedYear = 0;
  int get selectedYear => _selectedYear;

  List<int> get years => Summary(expenses).years;

  YearSummary get selectedYearSummary =>
      Summary(expenses).getYearSummary(selectedYear);

  ExpenseStatsPageModel({required this.provider});

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
    _selectedYear = _nearestOldestYear(DateTime.now().year, years);
    notifyListeners();
  }

  void selectYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }
}

int _nearestOldestYear(int fromYear, List<int> years) {
  years = years.toList()..sort();

  final distances = years.map((y) => (fromYear - y).abs()).toList();
  final smallestDistanceIx = distances.indexOf(min(distances)!);

  return years[smallestDistanceIx];
}
