import 'dart:io';

import 'package:dart_dependency_checker/src/errors.dart';
import 'package:yaml/yaml.dart';

/// Static utility to parse a pubspec.yaml file.
abstract final class PubspecYamlParser {
  /// Resolves a pubspec.yaml to [YamlMap] at [path].
  ///
  /// Throws a [PubspecNotFoundError] if the file could not be found.
  /// Throws a [PubspecInvalidError] if the file contents were invalid.
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
