import 'dart:io';

import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with invalid path message '
      'when path without pubspec.yaml has been provided', () {
    expect(
      () => YamlMapLoader.from(File('/pubspec.yaml')),
      throwsA(
        isA<PubspecNotFoundError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: /pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'throws a $PubspecNotValidError with invalid contents message '
      'when pubspec.yaml with empty contents has been provided', () {
    expect(
      () => YamlMapLoader.from(File('$emptyYamlPath/pubspec.yaml')),
      throwsA(
        isA<PubspecNotValidError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $emptyYamlPath/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'throws a $PubspecNotValidError with invalid contents message '
      'when pubspec.yaml with non yaml contents has been provided', () {
    final tempPath = Directory.systemTemp.path;
    final tempFile = File('$tempPath/pubspec.yaml');

    expect(
      () async => YamlMapLoader.from(await tempFile.create()),
      throwsA(
        isA<PubspecNotValidError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $tempPath/pubspec.yaml',
        ),
      ),
    );
  });

  test('loads expected', () {
    final yamlMap = YamlMapLoader.from(File('$noSourcesDirsPath/pubspec.yaml'));

    expect(
      yamlMap,
      const {
        'name': 'dart_dependency_checker_samples',
        'dependencies': {'meta': '^1.11.0'},
        'dev_dependencies': {'lints': '^3.0.0', 'test': '^1.25.0'},
      },
    );
  });
}
