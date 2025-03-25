import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_file_loader.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('name', () {
    test('resolves to null on missing "name" node', () {
      final yamlMap = YamlMapFileLoader.from(missingNameNodePath).yamlMap;

      expect(yamlMap.name, isNull);
    });

    test('resolves to some on provided "name" node', () {
      final yamlMap = YamlMapFileLoader.from(noDependenciesPath).yamlMap;

      expect(yamlMap.name, 'dart_dependency_checker_samples');
    });
  });

  group('packages', () {
    group('of $noDependenciesPath', () {
      test('resolves main dependencies', () {
        final yamlMap = YamlMapFileLoader.from(noDependenciesPath).yamlMap;

        expect(yamlMap.packages(DependencyType.mainDependencies), isEmpty);
      });

      test('resolves dev dependencies', () {
        final yamlMap = YamlMapFileLoader.from(noDependenciesPath).yamlMap;

        expect(yamlMap.packages(DependencyType.devDependencies), isEmpty);
      });
    });

    group('of $ymlFilePath', () {
      test('resolves main dependencies', () {
        final yamlMap = YamlMapFileLoader.from(ymlFilePath).yamlMap;

        expect(
          yamlMap.packages(DependencyType.mainDependencies),
          const {'meta'},
        );
      });

      test('resolves main dependencies', () {
        final yamlMap = YamlMapFileLoader.from(ymlFilePath).yamlMap;

        expect(
          yamlMap.packages(DependencyType.devDependencies),
          const {'lints', 'test'},
        );
      });
    });
  });
}
