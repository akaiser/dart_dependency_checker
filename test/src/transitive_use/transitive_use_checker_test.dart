import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_checker.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $CheckerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const TransitiveUseChecker(TransitiveUseParams(path: 'unknown')).check,
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
      const TransitiveUseChecker(TransitiveUseParams(path: path)).check,
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
      'providing $noDependenciesPath path '
      'returns no undeclared dependencies', () {
    const path = noDependenciesPath;

    expect(
      const TransitiveUseChecker(TransitiveUseParams(path: path)).check(),
      const TransitiveUseResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  test(
      'providing $ownReferencePath path '
      'ignores own package '
      'and returns no undeclared dependencies', () {
    const path = ownReferencePath;

    expect(
      const TransitiveUseChecker(TransitiveUseParams(path: path)).check(),
      const TransitiveUseResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  test(
      'providing $inMainButMissingInDev path '
      'ignores declared main in dev packages'
      'and returns no undeclared dependencies', () {
    const path = inMainButMissingInDev;

    expect(
      const TransitiveUseChecker(TransitiveUseParams(path: path)).check(),
      const TransitiveUseResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  test(
      'providing $noSourcesDirsPath path '
      'returns all undeclared main and dev dependencies', () {
    const path = noSourcesDirsPath;

    expect(
      const TransitiveUseChecker(TransitiveUseParams(path: path)).check(),
      const TransitiveUseResults(
        mainDependencies: {},
        devDependencies: {},
      ),
    );
  });

  group('providing $allSourcesDirsMultiPath path', () {
    const path = allSourcesDirsMultiPath;

    test('returns only undeclared main and dev dependencies', () {
      expect(
        const TransitiveUseChecker(TransitiveUseParams(path: path)).check(),
        const TransitiveUseResults(
          mainDependencies: {'equatable'},
          devDependencies: {'async', 'convert'},
        ),
      );
    });

    test('passed ignores will not be returned', () {
      expect(
        const TransitiveUseChecker(
          TransitiveUseParams(
            path: path,
            mainIgnores: {'equatable'},
            devIgnores: {'convert'},
          ),
        ).check(),
        const TransitiveUseResults(
          mainDependencies: {},
          devDependencies: {'async'},
        ),
      );
    });
  });
}
