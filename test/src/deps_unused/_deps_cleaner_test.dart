import 'dart:io';

import 'package:dart_dependency_checker/src/deps_unused/_deps_cleaner.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
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

      DepsCleaner.clean(results, sourceFile);

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

      DepsCleaner.clean(results, sourceFile);

      expect(
        sourceFile.read,
        '$sourcePath/expected_empty_dependencies.yaml'.read,
      );
    });

    test('will modify file if something was removed', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsCleaner.clean(
        const DepsUnusedResults(
          mainDependencies: {'meta'},
          devDependencies: {},
        ),
        sourceFile,
      );

      expect(lastModifiedBefore.isBefore(sourceFile.modified), isTrue);
    });

    test('will not modify file if nothing was removed', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsCleaner.clean(
        const DepsUnusedResults(
          mainDependencies: {'equatable'},
          devDependencies: {},
        ),
        sourceFile,
      );

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForFixingNoNodesPath path', () {
    const sourcePath = meantForFixingNoNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('passes with no changes', () {
      const results = DepsUnusedResults(
        mainDependencies: {},
        devDependencies: {},
      );

      DepsCleaner.clean(results, sourceFile);

      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });
}
