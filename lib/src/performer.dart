import 'package:dart_dependency_checker/src/_shared/params.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';

/// Base processor class.
abstract class Performer<I extends PathParam, O> {
  const Performer(this.params);

  /// Custom params required by any implementation of a [Performer].
  final I params;

  /// Resolves [O] after execution.
  ///
  /// Throws a [PubspecNotFoundError] when pubspec.yaml was not found.
  /// Throws a [PubspecNotValidError] when pubspec.yaml contents were invalid.
  O perform();
}
