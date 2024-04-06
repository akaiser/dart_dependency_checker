import 'package:dart_dependency_checker/src/_shared/results.dart';

/// Results from the [DepsUnusedChecker].
class DepsUnusedResults extends BaseResults {
  const DepsUnusedResults({
    required super.mainDependencies,
    required super.devDependencies,
  });
}
