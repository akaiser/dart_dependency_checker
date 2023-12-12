import 'dart:io';

import 'package:dart_dependency_checker/src/arguments_parser.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';
import 'package:yaml/yaml.dart';

// TODO(albert): this runner should just decide which mode to exec and print the results.
ExitCode run(List<String> args, [Logger logger = const Logger()]) {
  final arguments = ArgumentsParser.parse(args);

  if (arguments == null) {
    logger.warn(
      'One of mode type is required: '
      '${CheckerMode.values.map((e) => e.name).join(', ')}',
    );
    return const ExitCode(1);
  }

  final path = arguments.path;
  final pubspecYaml = _pubspecYaml(path);
  if (pubspecYaml == null) {
    logger.warn('Invalid pubspec.yml file path: $path');
    return const ExitCode(2);
  }

  final results = DepsUnusedChecker(
    path,
    pubspecYaml,
    arguments.devIgnores,
  ).makeItSo();

  final pubspecYamlPath = '$path/pubspec.yaml';
  if (!results.isEmpty) {
    logger.warn('== Found unused packages ==');
    logger.warn('Path: $pubspecYamlPath');
    if (results.dependencies.isNotEmpty) {
      logger.warn('Dependencies:');
      for (var dependency in results.dependencies) {
        logger.warn('  - $dependency');
      }
    }
    if (results.devDependencies.isNotEmpty) {
      logger.warn('Dev Dependencies:');
      for (var dependency in results.devDependencies) {
        logger.warn('  - $dependency');
      }
    }
    return const ExitCode(1);
  }
  logger.log('All good for: $pubspecYamlPath');

  return ExitCode(exitCode);
}

YamlMap? _pubspecYaml(String path) {
  final pubspecFile = File('$path/pubspec.yaml');

  if (pubspecFile.existsSync()) {
    return loadYaml(pubspecFile.readAsStringSync()) as YamlMap?;
  }
  return null;
}
