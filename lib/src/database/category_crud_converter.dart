import 'dart:ui';

import 'package:cents/src/domain/expense_category.dart';

/// CATEGORY:       Database    <->     Domain
///     id:         int?        <->     int
///     name:       String      <->     String
///     color:      int         <->     Color

const TABLE_CATEGORIES = 'categories';
const CATEGORY_COLUMN_ID = 'id';
const CATEGORY_COLUMN_NAME = 'name';
const CATEGORY_COLUMN_COLOR = 'color_as_argb';

Map<String, Object?> categoryToRow(ExpenseCategory category) {
  final columnId = categoryIdToColumn(category.id);

  return {
    if (columnId != null) CATEGORY_COLUMN_ID: columnId,
    CATEGORY_COLUMN_NAME: categoryNameToColumn(category.name),
    CATEGORY_COLUMN_COLOR: categoryColorToColumn(category.color),
  };
}

ExpenseCategory rowToCategory(Map<String, Object?> row) {
  return ExpenseCategory(
    id: categoryColumnToId(row[CATEGORY_COLUMN_ID]),
    name: categoryColumnToName(row[CATEGORY_COLUMN_NAME]),
    color: categoryColumnToColor(row[CATEGORY_COLUMN_COLOR]),
  );
}

int? categoryIdToColumn(int id) {
  return id == ExpenseCategory.UNSET_ID ? null : id;
}

String categoryNameToColumn(String name) {
  return name;
}

int categoryColorToColumn(Color color) {
  return color.value;
}

int categoryColumnToId(Object? columnId) {
  final id = columnId as int;
  assert(id != ExpenseCategory.UNSET_ID);

  return id;
}

String categoryColumnToName(Object? columnName) {
  return columnName as String;
}

Color categoryColumnToColor(Object? columnColor) {
  return Color(columnColor as int);
}
