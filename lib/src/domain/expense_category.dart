class ExpenseCategory implements Comparable<ExpenseCategory> {
  final String name;

  ExpenseCategory(String name) : name = name.trim();

  ExpenseCategory.uncategorized() : this('');

  @override
  bool operator ==(dynamic other) {
    return other is ExpenseCategory && hashCode == other.hashCode;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  int compareTo(ExpenseCategory other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return name;
  }
}
