import 'package:dart_dependency_checker/src/deps_unused/deps_unused_checker.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';

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

    late FileArrangeBuilder builder;

    setUp(() => builder = FileArrangeBuilder()..init(sourcePath));

    tearDown(() => builder.reset());

    test('will be removed from dev because it is already declared in main', () {
      const params = DepsUnusedParams(path: sourcePath, fix: true);

      expect(
        const DepsUnusedChecker(params).perform(),
        const DepsUnusedResults(
          mainDependencies: {},
          devDependencies: {'meta'},
        ),
      );
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('will not be removed from dev because it is ignored in main', () {
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
      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });

    test('will not be removed from dev because it is ignored in dev', () {
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
      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });
}
