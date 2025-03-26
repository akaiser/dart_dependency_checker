import 'package:equatable/equatable.dart';

/// Base class for params with a path.
abstract class PathParam extends Equatable {
  const PathParam({required this.path});

  /// Path to a directory containing a pubspec.yaml file.
  final String path;

  @override
  List<Object?> get props => [path];
}

/// Base class for params with a path and ignores.
abstract class PathWithIgnoresParams extends PathParam {
  const PathWithIgnoresParams({
    required super.path,
    this.mainIgnores = const {},
    this.devIgnores = const {},
  });

  /// Main ignores.
  final Set<String> mainIgnores;

  /// Dev ignores.
  final Set<String> devIgnores;

  @override
  List<Object?> get props => [...super.props, mainIgnores, devIgnores];
}
