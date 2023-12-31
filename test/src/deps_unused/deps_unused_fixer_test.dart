import 'dart:io';

import 'package:dart_dependency_checker/src/deps_unused/deps_unused_fixer.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  final sourceFile = File('$meantForFixingPath/pubspec.yaml');
  final sourceContent = sourceFile.readAsStringSync();

  tearDown(() => sourceFile.writeAsStringSync(sourceContent));

  test('cleanes source file', () {
    const results = DepsUnusedResults(
      dependencies: {'meta', 'bla_analytics'},
      devDependencies: {'integration_test', 'lints', 'bla_test_bed'},
    );

    DepsUnusedFixer.fix(results, meantForFixingPath);

    expect(
      sourceFile.readAsStringSync(),
      File('$meantForFixingPath/fixed.yaml').readAsStringSync(),
    );
  });
}
