import 'dart:io';

import 'package:dart_dependency_checker/src/deps_unused/deps_unused_fixer.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  test(
      'throws a $PubspecNotFoundError with invalid path message '
      'when path without pubspec.yaml has been provided', () {
    const results = DepsUnusedResults(
      mainDependencies: {},
      devDependencies: {},
    );

    expect(
      () => DepsUnusedFixer.fix(results, ''),
      throwsA(
        isA<PubspecNotFoundError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: /pubspec.yaml',
        ),
      ),
    );
  });

  group('providing $meantForFixingPath path', () {
    const sourcePath = meantForFixingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('cleanes source file', () {
      const results = DepsUnusedResults(
        mainDependencies: {'meta', 'bla_analytics'},
        devDependencies: {'integration_test', 'lints', 'bla_test_bed'},
      );

      DepsUnusedFixer.fix(results, sourcePath);

      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('leaves blank dependency sections', () {
      const results = DepsUnusedResults(
        mainDependencies: {
          'args',
          'meta',
          'bla_analytics',
          'bla_support',
        },
        devDependencies: {
          'flutter_test',
          'integration_test',
          'bla_dart_lints',
          'lints',
          'test',
          'bla_test_bed',
          'bla_other_bed',
        },
      );

      DepsUnusedFixer.fix(results, sourcePath);

      expect(
        sourceFile.read,
        '$sourcePath/expected_empty_dependencies.yaml'.read,
      );
    });
  });

  group('providing $meantForFixingEmptyPath path', () {
    const sourcePath = meantForFixingEmptyPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('passes with no changes', () {
      const results = DepsUnusedResults(
        mainDependencies: {},
        devDependencies: {},
      );

      DepsUnusedFixer.fix(results, sourcePath);

      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });
}

extension on File {
  String get read => readAsStringSync();
}

extension on String {
  String get read => File(this).read;
}
