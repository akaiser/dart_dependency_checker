import 'package:equatable/equatable.dart';

abstract class BaseError extends Equatable {
  const BaseError(this.path);

  final String path;

  String get message;

  @override
  List<Object> get props => [path];
}

class PubspecNotFoundError extends BaseError {
  const PubspecNotFoundError(super.path);

  @override
  String get message => 'Invalid pubspec.yaml file path: $path';
}

class PubspecNotValidError extends BaseError {
  const PubspecNotValidError(super.path);

  @override
  String get message => 'Invalid pubspec.yaml file contents in: $path';
}
