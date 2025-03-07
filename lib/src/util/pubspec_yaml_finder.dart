import 'dart:io';

import 'package:dart_dependency_checker/src/performer_error.dart';

/// Utility to find a pubspec yaml file.
abstract final class PubspecYamlFinder {
  /// Finds a pubspec yaml file at [path].
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  static File from(String path) {
    final yamlFile = File('$path/pubspec.yaml');
    if (yamlFile.existsSync()) {
      return yamlFile;
    }

    final ymlFile = File('$path/pubspec.yml');
    if (ymlFile.existsSync()) {
      return ymlFile;
    }

    throw PubspecNotFoundError(yamlFile.path);
  }
}
