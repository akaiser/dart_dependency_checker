import 'package:equatable/equatable.dart';

base class ArgumentsError extends Equatable implements Exception {
  const ArgumentsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
