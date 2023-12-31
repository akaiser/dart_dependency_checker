import 'dart:io';

import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/logger.dart';

class InternalDepsUnusedChecker extends DepsUnusedChecker
    with CheckWithExitMixin {
  const InternalDepsUnusedChecker(
    Logger logger,
    super.params,
  ) : _logger = logger;

  final Logger _logger;

  @override
  int checkWithExit() {
    try {
      final results = check();

      if (!results.isEmpty) {
        final messagePrefix = params.fix ? 'Fixed' : 'Found';
        _logger.warn('== $messagePrefix unused packages ==');
        _logger.warn('Path: ${params.path}/pubspec.yaml');
        _printDependencies('Dependencies', results.dependencies);
        _printDependencies('Dev Dependencies', results.devDependencies);
        return 1;
      }
    } on CheckerError catch (e) {
      _logger.error(e.message);
      return 2;
    }

    _logger.info('All clear!');
    return exitCode;
  }

  void _printDependencies(String label, Set<String> dependencies) {
    if (dependencies.isNotEmpty) {
      _logger.warn('$label:');
      for (final dependency in dependencies) {
        _logger.warn('  - $dependency');
      }
    }
  }
}
