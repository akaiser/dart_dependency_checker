import 'dart:io';

import 'package:yaml/yaml.dart';

abstract final class PubspecYamlParser {
  static YamlMap? from(String path) {
    final pubspecFile = File('$path/pubspec.yaml');

    if (pubspecFile.existsSync()) {
      return loadYaml(pubspecFile.readAsStringSync()) as YamlMap?;
    }
    return null;
  }
}
