import 'package:cents/src/domain/amount.dart';
import 'package:cents/src/domain/expense.dart';
import 'package:cents/src/domain/expense_category.dart';

/// EXPENSE:        Database    <->     Domain
///     id:         int?        <->     int
///     category:   int         <->     ExpenseCategory
///     cost:       int         <->     Amount
///     createdAt:  String      <->     DateTime
///     note:       String      <->     String

const TABLE_EXPENSES = 'expenses';
const EXPENSE_COLUMN_ID = 'id';
const EXPENSE_COLUMN_CATEGORY = 'category';
const EXPENSE_COLUMN_COST = 'cost_in_cents';
const EXPENSE_COLUMN_CREATED_AT = 'createdAt';
const EXPENSE_COLUMN_NOTE = 'note';

Map<String, Object?> expenseToRow(Expense expense) {
  final columnId = expenseIdToColumn(expense.id);

  return {
    if (columnId != null) EXPENSE_COLUMN_ID: columnId,
    EXPENSE_COLUMN_CATEGORY: expenseCategoryToColumn(expense.category),
    EXPENSE_COLUMN_COST: expenseCostToColumn(expense.cost),
    EXPENSE_COLUMN_CREATED_AT: expenseCreatedAtToColumn(expense.createdAt),
    EXPENSE_COLUMN_NOTE: expenseNoteToColumn(expense.note),
  };
}

Expense rowToExpense(
  Map<String, Object?> row,
  ExpenseCategory category,
) {
  return Expense(
    id: expenseColumnToId(row[EXPENSE_COLUMN_ID]),
    category: expenseColumnToCategory(row[EXPENSE_COLUMN_CATEGORY], category),
    cost: expenseColumnToCost(row[EXPENSE_COLUMN_COST]),
    createdAt: expenseColumnToCreatedAt(row[EXPENSE_COLUMN_CREATED_AT]),
    note: expenseColumnToNote(row[EXPENSE_COLUMN_NOTE]),
  );
}

int? expenseIdToColumn(int id) {
  return id == Expense.UNSET_ID ? null : id;
}

int expenseCategoryToColumn(ExpenseCategory category) {
  assert(category.id != ExpenseCategory.UNSET_ID);

  return category.id;
}

int expenseCostToColumn(Amount cost) {
  return cost.totalCents;
}

String expenseCreatedAtToColumn(DateTime createdAt) {
  return createdAt.toIso8601String();
}

String expenseNoteToColumn(String note) {
  return note;
}

int expenseColumnToId(Object? columnId) {
  final id = columnId as int;
  assert(id != Expense.UNSET_ID);

  return id;
}

ExpenseCategory expenseColumnToCategory(
  Object? columnCategory,
  ExpenseCategory category,
) {
  assert(category.id == columnCategory);

  return category;
}

Amount expenseColumnToCost(Object? columnCost) {
  return Amount.fromTotalCents(columnCost as int);
}

DateTime expenseColumnToCreatedAt(Object? columnCreatedAt) {
  return DateTime.parse(columnCreatedAt as String);
}

String expenseColumnToNote(Object? columnNote) {
  return columnNote as String;
}
