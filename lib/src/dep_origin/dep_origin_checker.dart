import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/dep_origin/dep_origin_params.dart';
import 'package:dart_dependency_checker/src/dep_origin/dep_origin_results.dart';

class DepOriginChecker extends Checker<DepOriginParams, DebOriginResults> {
  const DepOriginChecker(super.params);

  @override
  DebOriginResults check() => throw UnimplementedError();
}
