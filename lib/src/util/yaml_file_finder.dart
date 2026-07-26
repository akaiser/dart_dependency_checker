import 'dart:io';

import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';

/// Utility to find a pubspec yaml file.
abstract final class YamlFileFinder {
  /// Finds a pubspec yaml file at [path].
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  static File from(String path) {
    final yamlFile = '$path/pubspec.yaml'.file;
    if (yamlFile.existsSync()) {
      return yamlFile;
    }

    final ymlFile = '$path/pubspec.yml'.file;
    if (ymlFile.existsSync()) {
      return ymlFile;
    }

    throw PubspecNotFoundError(yamlFile.path);
  }
}
