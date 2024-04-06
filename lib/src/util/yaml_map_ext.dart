import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:yaml/yaml.dart';

extension YamlMapExt on YamlMap {
  Set<String> packages(DependencyType dependencyType) {
    final nodeValue = nodes[dependencyType.yamlNode]?.value as YamlMap?;
    return nodeValue?.keys.map((e) => e as String).toSet() ?? const {};
  }
}
