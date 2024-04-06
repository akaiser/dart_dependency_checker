import 'package:dart_dependency_checker/src/_shared/results.dart';

/// Results from the [TransitiveUseChecker].
class TransitiveUseResults extends BaseResults {
  const TransitiveUseResults({
    required super.mainDependencies,
    required super.devDependencies,
  });
}
