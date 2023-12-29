import 'package:dart_dependency_checker/dart_dependency_checker.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $CheckerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      () => const DepsUnusedChecker(DepsUnusedParams(path: 'unknown')).check(),
      throwsA(
        isA<CheckerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'throws a $CheckerError with proper message '
      'on invalid pubspec.yaml content', () {
    const path = emptyPubspecYamlPath;

    expect(
      () => const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
      throwsA(
        isA<CheckerError>().having(
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
        const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
        const DepsUnusedResults(
          dependencies: {'meta'},
          devDependencies: {'integration_test', 'lints'},
        ),
      );
    });

    test('passed ignores will not be returned', () {
      expect(
        const DepsUnusedChecker(
          DepsUnusedParams(
            path: path,
            devIgnores: {'integration_test'},
            mainIgnores: {'meta'},
          ),
        ).check(),
        const DepsUnusedResults(
          dependencies: {},
          devDependencies: {'lints'},
        ),
      );
    });
  });

  group('providing no_dependencies path', () {
    test('returns no unused dependencies', () {
      const path = noDependenciesPath;

      expect(
        const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
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
        const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
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
        const DepsUnusedChecker(
          DepsUnusedParams(
            path: path,
            devIgnores: {'lints', 'test'},
            mainIgnores: {'meta'},
          ),
        ).check(),
        const DepsUnusedResults(
          dependencies: {},
          devDependencies: {},
        ),
      );
    });
  });
}
