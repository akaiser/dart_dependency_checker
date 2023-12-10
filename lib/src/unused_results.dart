import 'package:meta/meta.dart';

@immutable
class UnusedResults {
  const UnusedResults({
    required this.dependencies,
    required this.devDependencies,
  });

  final Iterable<String> dependencies;
  final Iterable<String> devDependencies;

  bool get isEmpty => dependencies.isEmpty && devDependencies.isEmpty;
}
