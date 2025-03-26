import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with invalid path message '
      'when path without pubspec.yaml has been provided', () {
    expect(
      () => YamlFileFinder.from(''),
      throwsA(
        isA<PubspecNotFoundError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: /pubspec.yaml',
        ),
      ),
    );
  });

  test('finds yaml file', () {
    final file = YamlFileFinder.from(emptyYamlPath);

    expect(file.existsSync(), isTrue);
    expect(file.path, '$emptyYamlPath/pubspec.yaml');
  });

  test('finds yml file', () {
    final file = YamlFileFinder.from(ymlFilePath);

    expect(file.existsSync(), isTrue);
    expect(file.path, '$ymlFilePath/pubspec.yml');
  });

  test('prefers yaml over yml file extension', () {
    final file = YamlFileFinder.from(yamlAndYmlFilesPath);

    expect(file.existsSync(), isTrue);
    expect(file.path, '$yamlAndYmlFilesPath/pubspec.yaml');
  });
}
