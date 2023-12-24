import 'package:equatable/equatable.dart';

sealed class AppError extends Equatable implements Exception {
  const AppError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class PubspecNotFoundError extends AppError {
  const PubspecNotFoundError(String path)
      : super('Invalid pubspec.yaml file path: $path');
}

final class PubspecNotValidError extends AppError {
  const PubspecNotValidError(String path)
      : super('Invalid pubspec.yaml file contents in: $path');
}
