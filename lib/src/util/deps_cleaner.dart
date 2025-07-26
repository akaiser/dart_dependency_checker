import 'dart:io';

import 'package:dart_dependency_checker/src/util/yaml_file_utils.dart';

/// A very dumb and dangerous utility to read and write into the same
/// pubspec.yaml file.
abstract final class DepsCleaner {
  /// Reads `yamlFile`, removes dependencies and overrides file contents.
  ///
  /// Returns a set of actually removed dependencies.
  static Set<String> clean(
    File yamlFile, {
    required Set<String> mainDependencies,
    required Set<String> devDependencies,
  }) {
    final contents = StringBuffer();

    final dependenciesExp = RegExp('(${mainDependencies.join('|')}):');
    final devDependenciesExp = RegExp('(${devDependencies.join('|')}):');

    var dependenciesNodeFound = false;
    var devDependenciesNodeFound = false;
    var dependencyFound = false;
    var blankLineWritten = false;

    final removedDependencies = <String>{};

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
            removedDependencies.add(lt.split(':')[0]);
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

    if (removedDependencies.isNotEmpty) {
      yamlFile.writeAsStringSync(contents.toString());
    }

    return removedDependencies;
  }
}
