import 'dart:ui';

import 'package:quiver/core.dart';

class ExpenseCategory implements Comparable<ExpenseCategory> {
  static const UNSET_ID = 0;
  // Use Colors.blue.shade300 directly since it isn't a const value :|
  static const DEFAULT_COLOR = Color(0xFF64B5F6);

  final int id;
  final String name;
  final Color color;

  ExpenseCategory({
    this.id = ExpenseCategory.UNSET_ID,
    required this.name,
    this.color = ExpenseCategory.DEFAULT_COLOR,
  }) : assert(name.isNotEmpty);

  @override
  bool operator ==(dynamic other) {
    return other is ExpenseCategory && hashCode == other.hashCode;
  }

  @override
  int get hashCode => hash3(id, name, color);

  @override
  int compareTo(ExpenseCategory other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return '($id, $name, $color)';
  }

  ExpenseCategory copyWith({int? id, String? name, Color? color}) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
