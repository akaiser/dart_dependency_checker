import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with invalid path message '
      'when path without pubspec.yaml has been provided', () {
    expect(
      () => PubspecYamlFinder.from(''),
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
    final file = PubspecYamlFinder.from(emptyYamlPath);

    expect(file.existsSync(), isTrue);
    expect(file.path, 'test/resources/samples/empty_yaml/pubspec.yaml');
  });

  test('finds yml file', () {
    final file = PubspecYamlFinder.from(ymlFilePath);

    expect(file.existsSync(), isTrue);
    expect(file.path, 'test/resources/samples/yml_file/pubspec.yml');
  });

  test('prefers yaml over yml file extension', () {
    final file = PubspecYamlFinder.from(yamlAndYmlFilesPath);

    expect(file.existsSync(), isTrue);
    expect(file.path, 'test/resources/samples/yaml_and_yml_files/pubspec.yaml');
  });
}
