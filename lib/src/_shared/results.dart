import 'package:equatable/equatable.dart';

/// Base class for results.
abstract class BaseResults extends Equatable {
  const BaseResults({
    required this.mainDependencies,
    required this.devDependencies,
  });

  /// Main dependencies.
  final Set<String> mainDependencies;

  /// Dev dependencies.
  final Set<String> devDependencies;

  /// Whether there are any dependencies.
  bool get isEmpty => mainDependencies.isEmpty && devDependencies.isEmpty;

  @override
  List<Object> get props => [mainDependencies, devDependencies];
}
