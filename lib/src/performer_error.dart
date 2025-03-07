import 'package:equatable/equatable.dart';

/// Base class for [PubspecNotFoundError] and [PubspecNotValidError].
sealed class PerformerError extends Equatable implements Exception {
  const PerformerError(this.message);

  /// Message describing the issue.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Thrown when the pubspec.yaml was not found.
final class PubspecNotFoundError extends PerformerError {
  const PubspecNotFoundError(String path)
      : super('Invalid pubspec.yaml file path: $path');
}

/// Thrown when the pubspec.yaml contents were invalid.
final class PubspecNotValidError extends PerformerError {
  const PubspecNotValidError(String path)
      : super('Invalid pubspec.yaml file contents in: $path');
}
