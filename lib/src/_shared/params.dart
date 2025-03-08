import 'package:equatable/equatable.dart';

abstract class PathParam extends Equatable {
  const PathParam({required this.path});

  final String path;

  @override
  List<Object?> get props => [path];
}

abstract class PathWithIgnoresParams extends PathParam {
  const PathWithIgnoresParams({
    required super.path,
    this.mainIgnores = const {},
    this.devIgnores = const {},
  });

  final Set<String> mainIgnores;
  final Set<String> devIgnores;

  @override
  List<Object?> get props => [...super.props, mainIgnores, devIgnores];
}
