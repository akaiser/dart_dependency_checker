import 'package:dart_dependency_checker/src/_shared/params.dart';

/// Params for the [DepsUnusedChecker].
class DepsUnusedParams extends PathWithIgnoresParams {
  const DepsUnusedParams({
    required super.path,
    super.mainIgnores,
    super.devIgnores,
    this.fix = false,
  });

  final bool fix;

  @override
  List<Object?> get props => [...super.props, fix];
}
