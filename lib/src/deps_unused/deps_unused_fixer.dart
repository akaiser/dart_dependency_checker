import 'dart:io';

import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';

final _rootNode = RegExp(r'^\w+:');
final _leafNode = RegExp(r'^(\s{2})+(path|sdk|git|url|ref):');

/// A very dumb and dangerous utility to read and write
/// into the same pubspec.yaml file!?
abstract final class DepsUnusedFixer {
  /// Reads a pubspec.yaml file, searches for dependencies passed
  /// via [DepsUnusedResults] and overrides file content without them.
  ///
  /// Throws a [PubspecNotFoundError] when pubspec.yaml was not found.
  static void fix(DepsUnusedResults results, String path) {
    final pubspecFile = File('$path/pubspec.yaml');

    var contents = '';

    final dependenciesRegex = //
        RegExp('(${results.dependencies.join('|')}):');
    final devDependenciesRegex =
        RegExp('(${results.devDependencies.join('|')}):');

    var dependenciesNodeFound = false;
    var devDependenciesNodeFound = false;

    var dependencyFound = false;

    final dependenciesNode = DependencyType.dependencies.yamlNode;
    final devDependenciesNode = DependencyType.devDependencies.yamlNode;

    if (!pubspecFile.existsSync()) {
      throw PubspecNotFoundError(pubspecFile.path);
    }

    for (final line in pubspecFile.readAsLinesSync()) {
      if (line.startsWith('$dependenciesNode:')) {
        dependenciesNodeFound = true;
        contents += line.alt;
        continue;
      } else if (line.startsWith('$devDependenciesNode:')) {
        devDependenciesNodeFound = true;
        contents += line.alt;
        continue;
      }

      if (dependenciesNodeFound || devDependenciesNodeFound) {
        if (_rootNode.hasMatch(line)) {
          dependenciesNodeFound = false;
          devDependenciesNodeFound = false;
        } else {
          final trim = line.trim();
          if (dependenciesNodeFound && trim.startsWith(dependenciesRegex) ||
              devDependenciesNodeFound &&
                  trim.startsWith(devDependenciesRegex)) {
            dependencyFound = true;
            continue;
          }
        }

        if (dependencyFound) {
          if (_leafNode.hasMatch(line)) {
            continue;
          } else {
            dependencyFound = false;
          }
        }
      }

      contents += line.alt;
    }

    pubspecFile.writeAsStringSync(contents);
  }
}

extension on String {
  // and line terminator!
  String get alt => '$this${Platform.lineTerminator}';
}
