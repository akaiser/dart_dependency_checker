import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:equatable/equatable.dart';

class TransitiveUseParams extends Equatable {
  const TransitiveUseParams();

  static TransitiveUseParams from(ArgumentsResult result) =>
      const TransitiveUseParams();

  @override
  List<Object> get props => [];
}
