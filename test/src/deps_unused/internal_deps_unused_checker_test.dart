import 'package:dart_dependency_checker/src/deps_unused/internal_deps_unused_checker.dart';
import 'package:test/test.dart';

import '../_fake_logger.dart';
import '_test_helper.dart';

void main() {
  late FakeLogger logger;

  setUp(() => logger = FakeLogger());

  test('reports error on invalid pubspec.yaml path', () {
    final result = InternalDepsUnusedChecker(
      logger,
      params('unknown'),
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file path: unknown/pubspec.yaml
''');
  });

  test('reports error on invalid pubspec.yaml content', () {
    final result = InternalDepsUnusedChecker(
      logger,
      params(emptyPubspecYamlPath),
    ).checkWithExit();

    expect(result, 2);
    expect(logger.errorMessage, '''
Invalid pubspec.yaml file contents in: $emptyPubspecYamlPath/pubspec.yaml
''');
  });

  group('providing all_sources_dirs path', () {
    const path = allSourcesDirsPath;

    test('reports only unused main and dev dependencies', () {
      final result = InternalDepsUnusedChecker(
        logger,
        params(path),
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: $allSourcesDirsPath/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - integration_test
  - lints
''');
    });

    test('passed ignores will not be reported', () {
      final result = InternalDepsUnusedChecker(
        logger,
        params(path, const {'integration_test'}),
      ).checkWithExit();

      expect(result, 1);
      expect(logger.warnMessage, '''
== Found unused packages ==
Path: $allSourcesDirsPath/pubspec.yaml
Dependencies:
  - meta
Dev Dependencies:
  - lints
''');
    });
  });

  group('providing no_dependencies path', () {
    test('reports no unused dependencies', () {
      final result = InternalDepsUnusedChecker(
        logger,
        params(noDependenciesPath),
      ).checkWithExit();

      expect(result, 0);
      expect(logger.infoMessage, '''
All clear!
''');
    });
  });

  group('providing no_sources_dirs path', () {
    const path = noSourcesDirsPath;

    test('reports all declared main and dev dependencies', () {
      final result = InternalDepsUnusedChecker(
        logger,
        params(path),
      ).checkWithExit();

      expect(result, 1);
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: $noSourcesDirsPath/pubspec.yaml
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
      final result = InternalDepsUnusedChecker(
        logger,
        params(path, {'lints', 'test'}),
      ).checkWithExit();

      expect(result, 1);
      expect(
        logger.warnMessage,
        '''
== Found unused packages ==
Path: $noSourcesDirsPath/pubspec.yaml
Dependencies:
  - meta
''',
      );
    });
  });
}
