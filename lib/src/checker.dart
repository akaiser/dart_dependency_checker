import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';

abstract class Checker {
  const Checker(this.logger);

  final Logger logger;

  ExitCode makeItSo();
}
