import 'dart:io';

import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:yaml/yaml.dart';

/// Utility to load a pubspec yaml file.
abstract final class YamlMapLoader {
  /// Loads pubspec yaml file contents to [YamlMap] from [File].
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  /// Throws a [PubspecNotValidError] when pubspec yaml contents were invalid.
  static YamlMap from(File yamlFile) {
    if (!yamlFile.existsSync()) {
      throw PubspecNotFoundError(yamlFile.path);
    }

    final contents = yamlFile.readAsStringSync();
    final yamlMap = loadYaml(contents) as YamlMap?;

    if (yamlMap == null) {
      throw PubspecNotValidError(yamlFile.path);
    }

    return yamlMap;
  }
}
