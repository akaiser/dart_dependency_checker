import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_checker.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_params.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $CheckerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsUsedChecker(DepsUsedParams(path: 'unknown')).check,
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
      const DepsUsedChecker(DepsUsedParams(path: path)).check,
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
      'providing $ownReferencePath path '
      'ignores own package '
      'and returns just used dependencies', () {
    const path = ownReferencePath;

    expect(
      const DepsUsedChecker(DepsUsedParams(path: path)).check(),
      const DepsUsedResults(
        mainDependencies: {'args'},
        devDependencies: {'test'},
      ),
    );
  });

  group('providing $noSourcesDirsPath path', () {
    const path = noSourcesDirsPath;

    test('returns all used', () {
      expect(
        const DepsUsedChecker(DepsUsedParams(path: path)).check(),
        const DepsUsedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
    });

    test('passed ignores are just ignored', () {
      expect(
        const DepsUsedChecker(
          DepsUsedParams(
            path: path,
            mainIgnores: {'args'},
            devIgnores: {'async'},
          ),
        ).check(),
        const DepsUsedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
    });
  });

  group('providing $allSourcesDirsMultiPath path', () {
    const path = allSourcesDirsMultiPath;

    test('returns all used', () {
      expect(
        const DepsUsedChecker(DepsUsedParams(path: path)).check(),
        const DepsUsedResults(
          mainDependencies: {'args', 'equatable'},
          devDependencies: {'async', 'convert', 'test'},
        ),
      );
    });

    test('passed ignores will not be returned', () {
      expect(
        const DepsUsedChecker(
          DepsUsedParams(
            path: path,
            mainIgnores: {'args', 'equatable'},
            devIgnores: {'async', 'convert'},
          ),
        ).check(),
        const DepsUsedResults(
          mainDependencies: {},
          devDependencies: {'test'},
        ),
      );
    });
  });
}
