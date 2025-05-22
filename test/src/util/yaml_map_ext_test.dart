import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('name', () {
    test('resolves to null on missing "name" node', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/pubspec.yaml')
        ..writeAsStringSync('dependencies:\n  meta: ^1.11.0\n');

      final yamlMap = YamlMapLoader.from(tempFile);

      expect(yamlMap.name, isNull);
    });

    test('resolves to some on provided "name" node', () {
      final sourceFile = File('$noDependenciesPath/pubspec.yaml');
      final yamlMap = YamlMapLoader.from(sourceFile);

      expect(yamlMap.name, 'dart_dependency_checker_samples');
    });
  });

  group('packages', () {
    group('of $noDependenciesPath', () {
      final sourceFile = File('$noDependenciesPath/pubspec.yaml');

      test('resolves main dependencies', () {
        final yamlMap = YamlMapLoader.from(sourceFile);

        expect(yamlMap.packages(DependencyType.mainDependencies), isEmpty);
      });

      test('resolves dev dependencies', () {
        final yamlMap = YamlMapLoader.from(sourceFile);

        expect(yamlMap.packages(DependencyType.devDependencies), isEmpty);
      });
    });

    group('of $ymlFilePath', () {
      final sourceFile = File('$ymlFilePath/pubspec.yml');

      test('resolves main dependencies', () {
        final yamlMap = YamlMapLoader.from(sourceFile);

        expect(
          yamlMap.packages(DependencyType.mainDependencies),
          const {'meta'},
        );
      });

      test('resolves main dependencies', () {
        final yamlMap = YamlMapLoader.from(sourceFile);

        expect(
          yamlMap.packages(DependencyType.devDependencies),
          const {'lints', 'test'},
        );
      });
    });
  });
}
