import 'package:equatable/equatable.dart';

/// Params for the [DepsUnusedChecker].
class DepsUnusedParams extends Equatable {
  const DepsUnusedParams({
    required this.path,
    this.devIgnores = const {},
    this.mainIgnores = const {},
    this.fix = false,
  });

  final String path;
  final Set<String> devIgnores;
  final Set<String> mainIgnores;
  final bool fix;

  @override
  List<Object> get props => [path, devIgnores, mainIgnores, fix];
}
