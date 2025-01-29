import 'package:dart_dependency_checker/src/_shared/results.dart';

/// Results from the [DepsUsedChecker].
class DepsUsedResults extends BaseResults {
  const DepsUsedResults({
    required super.mainDependencies,
    required super.devDependencies,
  });
}
