extension ListFisrtTry<T> on List<T> {
  T? get firstTry {
    try {
      return first;
    } on StateError catch (_) {
      return null;
    }
  }
}
