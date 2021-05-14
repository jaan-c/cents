import 'package:quiver/core.dart';

class Pair<F, S> {
  final F first;
  final S second;

  const Pair(this.first, this.second);

  @override
  bool operator ==(dynamic other) {
    return other is Pair<F, S> &&
        first.hashCode == other.first.hashCode &&
        second.hashCode == other.second.hashCode;
  }

  @override
  int get hashCode => hash2(first, second);

  @override
  String toString() {
    return '($first, $second)';
  }
}
