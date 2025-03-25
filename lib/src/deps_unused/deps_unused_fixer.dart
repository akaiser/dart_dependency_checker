import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';

final _rootNodeExp = RegExp(r'^\w+:');
final _leafNodeExp = RegExp(r'^(\s{2})+(path|sdk|git|url|ref):');

/// A very dumb and dangerous utility to read and write into the same
/// pubspec.yaml file.
abstract final class DepsUnusedFixer {
  static final _dependenciesNode = DependencyType.mainDependencies.yamlNode;
  static final _devDependenciesNode = DependencyType.devDependencies.yamlNode;

  /// Reads a pubspec.yaml file, searches for dependencies passed
  /// via [DepsUnusedResults] and overrides file content without them.
  static void fix(DepsUnusedResults results, File yamlFile) {
    final contents = StringBuffer();

    final dependenciesRegex =
        RegExp('(${results.mainDependencies.join('|')}):');
    final devDependenciesRegex =
        RegExp('(${results.devDependencies.join('|')}):');

    var dependenciesNodeFound = false;
    var devDependenciesNodeFound = false;
    var dependencyFound = false;
    var blankLineWritten = false;
    var somethingRemoved = false;

    for (final line in yamlFile.readAsLinesSync()) {
      if (line.startsWith('$_dependenciesNode:')) {
        dependenciesNodeFound = true;
        blankLineWritten = false;
        contents.writeln(line);
        continue;
      } else if (line.startsWith('$_devDependenciesNode:')) {
        devDependenciesNodeFound = true;
        blankLineWritten = false;
        contents.writeln(line);
        continue;
      }

      if (dependenciesNodeFound || devDependenciesNodeFound) {
        if (_rootNodeExp.hasMatch(line)) {
          dependenciesNodeFound = false;
          devDependenciesNodeFound = false;
        } else {
          final lt = line.trim();
          if (dependenciesNodeFound && lt.startsWith(dependenciesRegex) ||
              devDependenciesNodeFound && lt.startsWith(devDependenciesRegex)) {
            dependencyFound = true;
            somethingRemoved = true;
            continue;
          }
        }

        if (dependencyFound) {
          if (_leafNodeExp.hasMatch(line)) {
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

      contents.writeln(line);
    }

    if (somethingRemoved) {
      yamlFile.writeAsStringSync(contents.toString());
    }
  }
}
