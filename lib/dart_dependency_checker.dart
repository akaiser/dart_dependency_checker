library dart_dependency_checker;

import 'dart:io';

import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';
import 'package:yaml/yaml.dart';

ExitCode run(List<String> args, [Logger logger = const Logger()]) {
  final testDirectory = args.firstOrNull ?? Directory.current.path;

  final pubspecYaml = _pubspecYaml(testDirectory);
  if (pubspecYaml == null) {
    logger.stderr('Invalid pubspec.yml file path: $testDirectory');
    return const ExitCode(2);
  }

  final results = Checker(testDirectory, pubspecYaml).makeItSo();

  if (!results.isEmpty) {
    logger.stderr('**************** Found unused packages ****************');
    logger.stderr('Path: $testDirectory/pubspec.yaml');
    logger.stderr('Dependencies: ${results.dependencies.withComma}');
    logger.stderr('Dev Dependencies: ${results.devDependencies.withComma}');
    logger.stderr('*******************************************************');
    return const ExitCode(1);
  }
  logger.stdout('All good!');

  return ExitCode(exitCode);
}

YamlMap? _pubspecYaml(String testDirectory) {
  final pubspecFile = File('$testDirectory/pubspec.yaml');

  if (pubspecFile.existsSync()) {
    return loadYaml(pubspecFile.readAsStringSync());
  }
  return null;
}

extension on Iterable<String> {
  String get withComma => join(', ');
}
