import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:equatable/equatable.dart';

abstract class BaseResults extends Equatable {
  const BaseResults({
    required this.mainDependencies,
    required this.devDependencies,
  });

  final Set<String> mainDependencies;

  final Set<String> devDependencies;

  bool get isEmpty => mainDependencies.isEmpty && devDependencies.isEmpty;

  Map<String, dynamic> toJson() => {
        'mainDependencies': mainDependencies.unmodifiable,
        'devDependencies': devDependencies.unmodifiable,
      };

  @override
  List<Object> get props => [mainDependencies, devDependencies];
}
