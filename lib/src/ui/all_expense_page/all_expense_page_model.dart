import 'package:cents/src/database/amount_range.dart';
import 'package:cents/src/database/expense_provider.dart';
import 'package:cents/src/domain/date_time_range.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';
import 'package:cents/src/ui/widgets/state_model.dart';

class AllExpensePageModel extends StateModel {
  final ExpenseProvider provider;

  var _expenses = <Expense>[];
  List<Expense> get filteredExpenses => _expenses.toList();

  var _categories = <ExpenseCategory>[];
  List<ExpenseCategory> get categories => _categories.toList();

  ExpenseCategory? _categoryFilter;
  ExpenseCategory? get categoryFilter => _categoryFilter;

  AmountRange? _costRangeFilter;
  AmountRange? get costRangeFilter => _costRangeFilter;

  DateTimeRange? _createdAtRangeFilter;
  DateTimeRange? get createdAtRangeFilter => _createdAtRangeFilter;

  String? _noteKeywordFilter;
  String? get noteKeywordFilter => _noteKeywordFilter;

  AllExpensePageModel({required this.provider});

  @override
  void initState() {
    super.initState();

    provider.addListener(_updateFilteredExpenses);
    provider.addListener(_updateCategories);

    _updateFilteredExpenses();
    _updateCategories();
  }

  @override
  void dispose() {
    provider.removeListener(_updateFilteredExpenses);
    provider.removeListener(_updateCategories);

    super.dispose();
  }

  Future<void> _updateFilteredExpenses() async {
    final expenses = await provider.getExpenseBy(
      categoryName: categoryFilter?.name,
      costRange: costRangeFilter,
      createdAtRange: createdAtRangeFilter,
      noteKeyword: noteKeywordFilter,
    );

    _expenses = expenses;
    notifyListeners();
  }

  Future<void> _updateCategories() async {
    final categories = await provider.getEveryCategory();

    _categories = categories;
    notifyListeners();
  }

  void setCategoryNameFilter(ExpenseCategory? newCategoryFilter) {
    _categoryFilter = newCategoryFilter;
    _updateFilteredExpenses();
  }

  void setCostRangeFilter(AmountRange? newCostRangeFilter) {
    _costRangeFilter = newCostRangeFilter;
    _updateFilteredExpenses();
  }

  void setCreatedAtRangeFilter(DateTimeRange? newCreatedAtRangeFilter) {
    _createdAtRangeFilter = newCreatedAtRangeFilter;
    _updateFilteredExpenses();
  }

  void setNoteKeywordFilter(String? newNoteKeywordFilter) {
    _noteKeywordFilter = newNoteKeywordFilter;
    _updateFilteredExpenses();
  }
}
