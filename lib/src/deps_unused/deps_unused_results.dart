import 'package:equatable/equatable.dart';

/// Results from the [DepsUnusedChecker].
class DepsUnusedResults extends Equatable {
  const DepsUnusedResults({
    required this.dependencies,
    required this.devDependencies,
  });

  /// Unused "main" dependencies.
  final Set<String> dependencies;

  /// Unused "dev" dependencies.
  final Set<String> devDependencies;

  bool get isEmpty => dependencies.isEmpty && devDependencies.isEmpty;

  @override
  List<Object> get props => [dependencies, devDependencies];
}
