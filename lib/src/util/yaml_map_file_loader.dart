import 'package:dart_dependency_checker/src/_shared/yaml_map_file.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';
import 'package:yaml/yaml.dart';

/// Utility to load a pubspec yaml file.
abstract final class YamlMapFileLoader {
  /// Loads pubspec yaml file content to [YamlMap] at [path].
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  /// Throws a [PubspecNotValidError] when pubspec yaml contents were invalid.
  static YamlMapFile from(String path) {
    final yamlFile = YamlFileFinder.from(path);
    final yamlMap = loadYaml(yamlFile.readAsStringSync()) as YamlMap?;

    if (yamlMap == null) {
      throw PubspecNotValidError(yamlFile.path);
    }

    return YamlMapFile(yamlMap, yamlFile);
  }
}
