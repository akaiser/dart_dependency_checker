import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:equatable/equatable.dart';

/// Params for the [DepsUnusedChecker].
class DepsUnusedParams extends Equatable {
  const DepsUnusedParams({
    required this.path,
    required this.devIgnores,
  });

  final String path;
  final Set<String> devIgnores;

  static DepsUnusedParams from(ArgumentsResult result) => DepsUnusedParams(
        path: result.path,
        devIgnores: result.devIgnores,
      );

  @override
  List<Object> get props => [path, devIgnores];
}
