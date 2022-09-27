/// Extension on [Iterable]
extension IterableExtension<T> on Iterable<T> {
  /// Puts [separator] between each element of the iterable.
  Iterable<T> separatedBy(T separator) sync* {
    for (int i = 0; i < 2 * length - 1; i++) {
      if (i.isEven) {
        yield elementAt((i + 1) ~/ 2);
      } else {
        yield separator;
      }
    }
  }

  /// Puts [separator] between each element of the iterable and returns it as a [List].
  List<T> separatedByToList(T separator) {
    return separatedBy(separator).toList();
  }

  /// Applies [f] to each element of the iterable and returns the result as a [List].
  List<R> mapToList<R>(R Function(T) f) {
    return map(f).toList();
  }

  /// Returns the element at the given [index].
  T at(int index) {
    assert(index >= 0 && index < length, 'Index out of bounds');
    return elementAt(index);
  }

  /// Followed by.
  Iterable<T> eachFollowedBy(T other) sync* {
    for (final element in this) {
      yield element;
      yield other;
    }
  }
}
