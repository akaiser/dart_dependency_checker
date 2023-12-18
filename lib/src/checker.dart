/// Base checker class.
abstract class Checker<I, O> {
  const Checker(this.params);

  final I params;

  /// Resolves [O] after execution.
  /// Throws a [PubspecNotFoundError] if the pubspec.yaml was not found.
  O check();
}

mixin CheckWithExitMixin {
  int checkWithExit();
}
