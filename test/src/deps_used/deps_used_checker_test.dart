import 'package:dart_dependency_checker/src/deps_used/deps_used_checker.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_params.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
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
