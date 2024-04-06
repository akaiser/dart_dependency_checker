import 'dart:io';

import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';

final _rootNode = RegExp(r'^\w+:');
final _leafNode = RegExp(r'^(\s{2})+(path|sdk|git|url|ref):');

/// A very dumb and dangerous utility to read and write into the same
/// pubspec.yaml file.
abstract final class DepsUnusedFixer {
  /// Reads a pubspec.yaml file, searches for dependencies passed
  /// via [DepsUnusedResults] and overrides file content without them.
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  static void fix(DepsUnusedResults results, String path) {
    final file = PubspecYamlFinder.from(path);

    var contents = '';

    final dependenciesRegex = //
        RegExp('(${results.mainDependencies.join('|')}):');
    final devDependenciesRegex =
        RegExp('(${results.devDependencies.join('|')}):');

    var dependenciesNodeFound = false;
    var devDependenciesNodeFound = false;

    var dependencyFound = false;
    var blankLineWritten = false;

    final dependenciesNode = DependencyType.mainDependencies.yamlNode;
    final devDependenciesNode = DependencyType.devDependencies.yamlNode;

    for (final line in file.readAsLinesSync()) {
      if (line.startsWith('$dependenciesNode:')) {
        dependenciesNodeFound = true;
        contents += line.withLineTerminator;
        continue;
      } else if (line.startsWith('$devDependenciesNode:')) {
        devDependenciesNodeFound = true;
        contents += line.withLineTerminator;
        continue;
      }

      if (dependenciesNodeFound || devDependenciesNodeFound) {
        if (_rootNode.hasMatch(line)) {
          dependenciesNodeFound = false;
          devDependenciesNodeFound = false;
        } else {
          final lt = line.trim();
          if (dependenciesNodeFound && lt.startsWith(dependenciesRegex) ||
              devDependenciesNodeFound && lt.startsWith(devDependenciesRegex)) {
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

      if (line.trim().isEmpty) {
        if (blankLineWritten) {
          continue;
        } else {
          blankLineWritten = true;
        }
      } else {
        blankLineWritten = false;
      }

      contents += line.withLineTerminator;
    }

    file.writeAsStringSync(contents);
  }
}

extension on String {
  String get withLineTerminator => '$this${Platform.lineTerminator}';
}
