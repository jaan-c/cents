class ExpenseCategory {
  final String name;

  const ExpenseCategory(this.name);

  const ExpenseCategory.uncategorized() : this("");

  bool operator ==(dynamic other) {
    return other is ExpenseCategory && hashCode == other.hashCode;
  }

  @override
  int get hashCode => name.hashCode;
}
