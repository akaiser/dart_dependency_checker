import 'package:equatable/equatable.dart';

sealed class CheckerError extends Equatable implements Exception {
  const CheckerError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class PubspecNotFoundError extends CheckerError {
  const PubspecNotFoundError(String path)
      : super('Invalid pubspec.yaml file path: $path');
}

final class PubspecNotValidError extends CheckerError {
  const PubspecNotValidError(String path)
      : super('Invalid pubspec.yaml file contents in: $path');
}
