extension IterableExt<T> on Iterable<T> {
  Set<T> get unmodifiable => Set.unmodifiable(this);

  Iterable<T> sort([int Function(T a, T b)? compare]) =>
      toList()..sort(compare);
}
