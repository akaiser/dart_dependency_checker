import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $CheckerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: 'unknown')).check,
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
    const path = emptyYamlPath;

    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: path)).check,
      throwsA(
        isA<CheckerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $path/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'providing no_dependencies path '
      'returns no unused dependencies', () {
    const path = noDependenciesPath;

    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
      const DepsUnusedResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  group('providing all_sources_dirs path', () {
    const path = allSourcesDirsPath;

    test('returns only unused main and dev dependencies', () {
      expect(
        const DepsUnusedChecker(DepsUnusedParams(path: path)).check(),
        const DepsUnusedResults(
          mainDependencies: {'meta'},
          devDependencies: {'integration_test', 'lints'},
        ),
      );
    });

    test('passed ignores will not be returned', () {
      expect(
        const DepsUnusedChecker(
          DepsUnusedParams(
            path: path,
            mainIgnores: {'meta'},
            devIgnores: {'integration_test'},
          ),
        ).check(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {'lints'},
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
          mainDependencies: {'meta'},
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
            mainIgnores: {'meta'},
            devIgnores: {'lints', 'test'},
          ),
        ).check(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
    });
  });
}
