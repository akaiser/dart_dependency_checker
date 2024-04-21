import 'package:equatable/equatable.dart';

abstract class BaseResults extends Equatable {
  const BaseResults({
    required this.mainDependencies,
    required this.devDependencies,
  });

  final Set<String> mainDependencies;

  final Set<String> devDependencies;

  bool get isEmpty => mainDependencies.isEmpty && devDependencies.isEmpty;

  @override
  List<Object> get props => [mainDependencies, devDependencies];
}
