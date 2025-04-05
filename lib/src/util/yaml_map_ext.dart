import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:yaml/yaml.dart';

extension YamlMapExt on YamlMap {
  String? get name => this['name'] as String?;

  Set<String> packages(DependencyType dependencyType) =>
      node(dependencyType)?.keys.cast<String>().unmodifiable ?? const {};

  YamlMap? node(DependencyType dependencyType) =>
      nodes[dependencyType.yamlNode]?.value as YamlMap?;
}
