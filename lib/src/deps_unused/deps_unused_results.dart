import 'package:equatable/equatable.dart';

class DepsUnusedResults extends Equatable {
  const DepsUnusedResults({
    required this.dependencies,
    required this.devDependencies,
  });

  final Set<String> dependencies;
  final Set<String> devDependencies;

  bool get isEmpty => dependencies.isEmpty && devDependencies.isEmpty;

  @override
  List<Object> get props => [dependencies, devDependencies];
}
