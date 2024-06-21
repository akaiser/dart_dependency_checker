extension IterableExt<T> on Iterable<T> {
  Set<T> get unmodifiable => Set.unmodifiable(this);
}
