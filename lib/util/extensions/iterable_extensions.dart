extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> distinctBy<R>(R Function(T) keySelector) {
    final seenKeys = <R>{};
    final distinctElements = <T>[];

    for (final element in this) {
      final key = keySelector(element);
      if (seenKeys.add(key)) {
        distinctElements.add(element);
      }
    }

    return distinctElements;
  }
}
