import 'dart:io';

import 'package:dart_dependency_checker/src/checker_error.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_fixer.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  final sourceFile = File('$meantForFixingPath/pubspec.yaml');
  final sourceContent = sourceFile.readAsStringSync();

  tearDown(() => sourceFile.writeAsStringSync(sourceContent));

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

  test('cleanes source file', () {
    const results = DepsUnusedResults(
      mainDependencies: {'meta', 'bla_analytics'},
      devDependencies: {'integration_test', 'lints', 'bla_test_bed'},
    );

    DepsUnusedFixer.fix(results, meantForFixingPath);

    expect(
      sourceFile.readAsStringSync(),
      File('$meantForFixingPath/expected.yaml').readAsStringSync(),
    );
  });
}
