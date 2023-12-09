import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:dart_dependency_checker/src/checker.dart';

Future<void> main(List<String> args) async {
  final console = Console();

  final testDirectory = args.isNotEmpty ? args[0] : Directory.current.path;

  final pubspecYaml = getPubspecYaml(testDirectory);
  if (pubspecYaml == null) {
    console.writeErrorLine('Invalid pubspec.yml file path: $testDirectory');
    exit(2);
  }

  final unusedDependencies = findUnusedDependencies(testDirectory, pubspecYaml);

  if (unusedDependencies.isNotEmpty) {
    console.writeErrorLine('### Found unused packages ###');
    console.writeErrorLine('Path: $testDirectory/pubspec.yaml');
    console.writeErrorLine('Dependencies: ${unusedDependencies.join(', ')}');
    console.writeErrorLine('Dev Dependencies: TODO');
    console.writeErrorLine('#############################');
    exit(2);
  }
  console.writeLine('All good!');

  exit(exitCode);
}
