import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense_category.dart';

extension AmountToColumn on Amount {
  int toColumn() {
    return totalCents;
  }
}

extension AmountFromColumn on int {
  Amount toCost() {
    return Amount.fromTotalCents(this);
  }
}

extension ExpenseCategoryToColumn on ExpenseCategory {
  String toColumn() {
    return name;
  }
}

extension ExpenseCategoryFromColumn on String {
  ExpenseCategory toCategory() {
    return ExpenseCategory(this);
  }
}

extension DateTimeToColumn on DateTime {
  String toColumn() {
    return toIso8601String();
  }
}

extension DateTimeFromColumn on String {
  DateTime toDateTime() {
    return DateTime.parse(this);
  }
}
