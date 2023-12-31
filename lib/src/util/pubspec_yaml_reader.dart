import 'dart:io';

import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:yaml/yaml.dart';

/// Utility to read a pubspec.yaml file.
abstract final class PubspecYamlReader {
  /// Resolves a pubspec.yaml to [YamlMap] at [path].
  ///
  /// Throws a [PubspecNotFoundError] when pubspec.yaml was not found.
  /// Throws a [PubspecInvalidError] when pubspec.yaml contents were invalid.
  static YamlMap from(String path) {
    final pubspecFile = File('$path/pubspec.yaml');

    if (!pubspecFile.existsSync()) {
      throw PubspecNotFoundError(pubspecFile.path);
    }

    final pubspecYaml = loadYaml(pubspecFile.readAsStringSync()) as YamlMap?;

    if (pubspecYaml == null) {
      throw PubspecNotValidError(pubspecFile.path);
    }

    return pubspecYaml;
  }
}
