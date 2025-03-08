import 'package:dart_dependency_checker/src/_shared/params.dart';

/// Params for the [TransitiveUseChecker].
class TransitiveUseParams extends PathWithIgnoresParams {
  const TransitiveUseParams({
    required super.path,
    super.mainIgnores,
    super.devIgnores,
  });
}
