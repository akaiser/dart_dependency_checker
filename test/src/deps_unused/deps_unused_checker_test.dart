import 'dart:io';

import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: 'unknown')).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml content', () {
    const path = emptyYamlPath;

    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: path)).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file contents in: $path/pubspec.yaml',
        ),
      ),
    );
  });

  test(
      'providing $noDependenciesPath path '
      'returns no unused dependencies', () {
    const path = noDependenciesPath;

    expect(
      const DepsUnusedChecker(DepsUnusedParams(path: path)).perform(),
      const DepsUnusedResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  group('providing $allSourcesDirsPath path', () {
    const path = allSourcesDirsPath;

    test('returns only unused main and dev dependencies', () {
      expect(
        const DepsUnusedChecker(DepsUnusedParams(path: path)).perform(),
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
        ).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {'lints'},
        ),
      );
    });
  });

  group('providing $noSourcesDirsPath path', () {
    const path = noSourcesDirsPath;

    test('returns all declared main and dev dependencies', () {
      expect(
        const DepsUnusedChecker(DepsUnusedParams(path: path)).perform(),
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
        ).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
    });
  });

  group(
      'providing $meantForFixingMissingDevDupe path '
      'where a package is used and declared in main and dev', () {
    const sourcePath = meantForFixingMissingDevDupe;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will be removed from dev because it is already declared in main', () {
      const params = DepsUnusedParams(path: sourcePath, fix: true);

      expect(
        const DepsUnusedChecker(params).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {'meta'},
        ),
      );
      expect(sourceFile.read, '$sourcePath/expected.yaml'.read);
    });

    test('will not be removed from dev because it is ignored in main', () {
      final lastModifiedBefore = sourceFile.modified;
      const params = DepsUnusedParams(
        path: sourcePath,
        mainIgnores: {'meta'},
        fix: true,
      );

      expect(
        const DepsUnusedChecker(params).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });

    test('will not be removed from dev because it is ignored in dev', () {
      final lastModifiedBefore = sourceFile.modified;
      const params = DepsUnusedParams(
        path: sourcePath,
        devIgnores: {'meta'},
        fix: true,
      );

      expect(
        const DepsUnusedChecker(params).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {},
        ),
      );
      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });
}
