extension AssertNonNullRowValues on Map<String, Object?> {
  Map<String, Object> assertNotNullValues() {
    return Map.fromEntries(entries.map((e) => MapEntry(e.key, e.value!)));
  }
}

extension ListFisrtTry<T> on List<T> {
  T? get firstTry {
    try {
      return first;
    } on StateError catch (_) {
      return null;
    }
  }
}
