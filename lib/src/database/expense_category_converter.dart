import 'package:cents/src/domain/expense_category.dart';
import 'package:floor/floor.dart';

class ExpenseCategoryConverter extends TypeConverter<ExpenseCategory, String> {
  @override
  String encode(ExpenseCategory category) {
    return category.name;
  }

  @override
  ExpenseCategory decode(String categoryName) {
    return ExpenseCategory(categoryName);
  }
}
