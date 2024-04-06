import 'package:dart_dependency_checker/src/_shared/params.dart';

/// Params for the [DepsUnusedChecker].
class DepsUnusedParams extends BaseParams {
  const DepsUnusedParams({
    required super.path,
    super.mainIgnores,
    super.devIgnores,
    super.fix,
  });
}
