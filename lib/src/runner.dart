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
    logger.stderr(
      'One of mode type is required: '
      '${CheckerMode.values.map((e) => e.name).join(', ')}',
    );
    return const ExitCode(1);
  }

  final path = arguments.path;
  final pubspecYaml = _pubspecYaml(path);
  if (pubspecYaml == null) {
    logger.stderr('Invalid pubspec.yml file path: $path');
    return const ExitCode(2);
  }

  final results = DepsUnusedChecker(
    path,
    pubspecYaml,
    arguments.devIgnores,
  ).makeItSo();

  if (!results.isEmpty) {
    logger.stderr('**************** Found unused packages ****************');
    logger.stderr('Path: $path/pubspec.yaml');
    logger.stderr('Dependencies: ${results.dependencies.withComma}');
    logger.stderr('Dev Dependencies: ${results.devDependencies.withComma}');
    logger.stderr('*******************************************************');
    return const ExitCode(1);
  }
  logger.stdout('All good!');

  return ExitCode(exitCode);
}

YamlMap? _pubspecYaml(String path) {
  final pubspecFile = File('$path/pubspec.yaml');

  if (pubspecFile.existsSync()) {
    return loadYaml(pubspecFile.readAsStringSync()) as YamlMap?;
  }
  return null;
}

extension on Set<String> {
  String get withComma => join(', ');
}
