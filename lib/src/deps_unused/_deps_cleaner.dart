import 'dart:io';

import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_utils.dart';

/// A very dumb and dangerous utility to read and write into the same
/// pubspec.yaml file.
abstract final class DepsCleaner {
  /// Reads passed `yamlFile`, removes dependencies passed via
  /// [DepsUnusedResults] and overrides file contents.
  static void clean(DepsUnusedResults results, File yamlFile) {
    final contents = StringBuffer();

    final dependenciesExp = //
        RegExp('(${results.mainDependencies.join('|')}):');
    final devDependenciesExp =
        RegExp('(${results.devDependencies.join('|')}):');

    var dependenciesNodeFound = false;
    var devDependenciesNodeFound = false;
    var dependencyFound = false;
    var blankLineWritten = false;
    var somethingRemoved = false;

    final lines = yamlFile.readAsLinesSync();

    for (final line in lines) {
      if (line.startsWith('$mainDependenciesNode:')) {
        dependenciesNodeFound = true;
        blankLineWritten = false;
        contents.writeln(line);
        continue;
      } else if (line.startsWith('$devDependenciesNode:')) {
        devDependenciesNodeFound = true;
        blankLineWritten = false;
        contents.writeln(line);
        continue;
      }

      if (dependenciesNodeFound || devDependenciesNodeFound) {
        if (rootNodeExp.hasMatch(line)) {
          dependenciesNodeFound = false;
          devDependenciesNodeFound = false;
        } else {
          final lt = line.trim();
          if (dependenciesNodeFound && lt.startsWith(dependenciesExp) ||
              devDependenciesNodeFound && lt.startsWith(devDependenciesExp)) {
            dependencyFound = true;
            somethingRemoved = true;
            continue;
          }
        }

        if (dependencyFound) {
          if (depLocationNodeExp.hasMatch(line)) {
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
