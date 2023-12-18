import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';

class TransitiveUseChecker
    extends Checker<TransitiveUseParams, TransitiveUseResults> {
  const TransitiveUseChecker(super.params);

  @override
  TransitiveUseResults check() => throw UnimplementedError();
}
