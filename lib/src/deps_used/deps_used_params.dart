import 'package:dart_dependency_checker/src/_shared/params.dart';

/// Params for the [DepsUsedChecker].
class DepsUsedParams extends PathWithIgnoresParams {
  const DepsUsedParams({
    required super.path,
    super.mainIgnores,
    super.devIgnores,
  });
}
