import 'package:equatable/equatable.dart';

class ExitCode extends Equatable {
  const ExitCode(this.code);

  final int code;

  @override
  List<Object> get props => [code];
}
