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
}
