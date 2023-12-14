import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_parser.dart';
import 'package:test/test.dart';

import '../_fake_logger.dart';

void main() {
  late FakeLogger logger;

  setUp(() => logger = FakeLogger());

  ArgumentsResult arguments(String path, [Set<String>? devIgnores]) =>
      ArgumentsResult(
        mode: CheckerMode.depsUnused,
        path: path,
        devIgnores: devIgnores ?? const {},
      );

  group('providing no_sources_dirs path', () {
    const path = 'test/resources/deps_unused/no_sources_dirs';
    final pubspecYaml = PubspecYamlParser.from(path)!;

    test('reports all declared main and dev dependencies', () {
      final result = DepsUnusedChecker(
        logger,
        arguments(path),
        pubspecYaml,
      ).makeItSo();

      expect(result, const ExitCode(1));
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: test/resources/deps_unused/no_sources_dirs/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - lints
  - test
''',
      );
    });

    test(
        'passed ignores will not be reported '
        'even if no sources were found', () {
      final result = DepsUnusedChecker(
        logger,
        arguments(path, {'lints', 'test'}),
        pubspecYaml,
      ).makeItSo();

      expect(result, const ExitCode(1));
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: test/resources/deps_unused/no_sources_dirs/pubspec.yaml
Dependencies:
  - meta
''',
      );
    });
  });

  group('providing all_sources_dirs path', () {
    const path = 'test/resources/deps_unused/all_sources_dirs';
    final pubspecYaml = PubspecYamlParser.from(path)!;

    test('reports only unused main and dev dependencies', () {
      final result = DepsUnusedChecker(
        logger,
        arguments(path),
        pubspecYaml,
      ).makeItSo();

      expect(result, const ExitCode(1));
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: test/resources/deps_unused/all_sources_dirs/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - integration_test
  - lints
''');
    });

    test('passed ignores will not be reported', () {
      final result = DepsUnusedChecker(
        logger,
        arguments(path, const {'integration_test'}),
        pubspecYaml,
      ).makeItSo();

      expect(result, const ExitCode(1));
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: test/resources/deps_unused/all_sources_dirs/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - lints
''');
    });
  });

  group('providing no_dependencies path', () {
    const path = 'test/resources/deps_unused/no_dependencies';
    final pubspecYaml = PubspecYamlParser.from(path)!;

    test('reports no unused dependencies', () {
      final result = DepsUnusedChecker(
        logger,
        arguments(path),
        pubspecYaml,
      ).makeItSo();

      expect(result, const ExitCode(0));
      expect(logger.infoMessage, '''
All clear!
''');
    });
  });
}
