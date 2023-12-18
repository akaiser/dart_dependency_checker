import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/errors.dart';
import 'package:test/test.dart';

import '_test_helper.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      () => DepsUnusedChecker(params('unknown')).check(),
      throwsA(
        isA<PubspecNotFoundError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'throws a $PubspecNotValidError with proper message '
      'on invalid pubspec.yaml content', () {
    expect(
      () => DepsUnusedChecker(params(emptyPubspecYamlPath)).check(),
      throwsA(
        isA<PubspecNotValidError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $emptyPubspecYamlPath/pubspec.yaml',
        ),
      ),
    );
  });

  group('providing all_sources_dirs path', () {
    const path = allSourcesDirsPath;

    test('returns only unused main and dev dependencies', () {
      expect(
        DepsUnusedChecker(params(path)).check(),
        const DepsUnusedResults(
          dependencies: {'meta'},
          devDependencies: {'integration_test', 'lints'},
        ),
      );
    });

    test('passed ignores will not be returned', () {
      expect(
        DepsUnusedChecker(params(path, const {'integration_test'})).check(),
        const DepsUnusedResults(
          dependencies: {'meta'},
          devDependencies: {'lints'},
        ),
      );
    });
  });

  group('providing no_dependencies path', () {
    test('returns no unused dependencies', () {
      expect(
        DepsUnusedChecker(params(noDependenciesPath)).check(),
        const DepsUnusedResults(
          dependencies: {},
          devDependencies: {},
        ),
      );
    });
  });

  group('providing no_sources_dirs path', () {
    const path = noSourcesDirsPath;

    test('returns all declared main and dev dependencies', () {
      expect(
        DepsUnusedChecker(params(path)).check(),
        const DepsUnusedResults(
          dependencies: {'meta'},
          devDependencies: {'lints', 'test'},
        ),
      );
    });

    test(
        'passed ignores will not be returned '
        'even if no sources were found', () {
      expect(
        DepsUnusedChecker(params(path, {'lints', 'test'})).check(),
        const DepsUnusedResults(
          dependencies: {'meta'},
          devDependencies: {},
        ),
      );
    });
  });
}
