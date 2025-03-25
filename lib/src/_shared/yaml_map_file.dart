import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

class YamlMapFile extends Equatable {
  const YamlMapFile(this.yamlMap, this.yamlFile);

  final YamlMap yamlMap;
  final File yamlFile;

  @override
  List<Object?> get props => [yamlMap, yamlFile];
}
