extension StringCondition on String {
  bool isBlank() {
    return this.trim().length == 0;
  }
}
