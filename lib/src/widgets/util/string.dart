extension StringCondition on String {
  bool isBlank() {
    return trim().isEmpty;
  }

  bool isNotBlank() {
    return !isBlank();
  }
}
