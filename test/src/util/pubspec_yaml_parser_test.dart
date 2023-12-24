import 'package:dart_dependency_checker/dart_dependency_checker.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_parser.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with invalid path message '
      'when path without pubspec.yaml has been provided', () {
    expect(
      () => PubspecYamlParser.from(''),
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
      () => PubspecYamlParser.from(emptyPubspecYamlPath),
      throwsA(
        isA<PubspecNotValidError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $emptyPubspecYamlPath/pubspec.yaml',
        ),
      ),
    );
  });

  test('maps to $YamlMap', () {
    expect(
      PubspecYamlParser.from(noSourcesDirsPath),
      {
        'name': 'testing',
        'dependencies': {'meta': '^1.11.0'},
        'dev_dependencies': {'lints': '^3.0.0', 'test': '^1.25.0'},
      },
    );
  });
}
