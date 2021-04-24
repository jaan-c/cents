extension StringExt on String {
  bool get isBlank {
    return trim().isEmpty;
  }

  bool get isNotBlank {
    return !isBlank;
  }
}
