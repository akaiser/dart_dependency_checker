import 'package:dart_dependency_checker/src/checker_error.dart';

/// Base checker class.
abstract class Checker<I, O> {
  const Checker(this.params);

  /// Custom params required by any implementation of a [Checker].
  final I params;

  /// Resolves [O] after execution.
  ///
  /// Throws a [PubspecNotFoundError] when pubspec.yaml was not found.
  /// Throws a [PubspecNotValidError] when pubspec.yaml contents were invalid.
  O check();
}
