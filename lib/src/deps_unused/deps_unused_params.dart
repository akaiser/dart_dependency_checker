import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:equatable/equatable.dart';

/// Params for the [DepsUnusedChecker].
class DepsUnusedParams extends Equatable {
  const DepsUnusedParams({
    required this.path,
    this.devIgnores = const {},
    this.mainIgnores = const {},
  });

  final String path;
  final Set<String> devIgnores;
  final Set<String> mainIgnores;

  static DepsUnusedParams from(ArgumentsResult result) => DepsUnusedParams(
        path: result.path,
        devIgnores: result.devIgnores,
        mainIgnores: result.mainIgnores,
      );

  @override
  List<Object> get props => [path, devIgnores, mainIgnores];
}
