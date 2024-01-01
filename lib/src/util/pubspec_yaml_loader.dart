import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';
import 'package:yaml/yaml.dart';

/// Utility to load a pubspec yaml file.
abstract final class PubspecYamlLoader {
  /// Loads pubspec yaml file content to [YamlMap] at [path].
  ///
  /// Throws a [PubspecNotFoundError] when no pubspec yaml file was found.
  /// Throws a [PubspecInvalidError] when pubspec yaml contents were invalid.
  static YamlMap from(String path) {
    final file = PubspecYamlFinder.from(path);
    final yaml = loadYaml(file.readAsStringSync()) as YamlMap?;

    if (yaml == null) {
      throw PubspecNotValidError(file.path);
    }

    return yaml;
  }
}
