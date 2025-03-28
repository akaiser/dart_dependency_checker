import 'dart:io';

import 'package:dart_dependency_checker/src/deps_sort/deps_sort_params.dart';
import 'package:dart_dependency_checker/src/deps_sort/deps_sort_performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsSortPerformer(DepsSortParams(path: 'unknown')).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  group('providing $meantForSortingPath path', () {
    const sourcePath = meantForSortingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will sort all dependencies', () {
      const params = DepsSortParams(path: sourcePath);

      final result = const DepsSortPerformer(params).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will modify file', () async {
      const params = DepsSortParams(path: sourcePath);
      final lastModifiedBefore = sourceFile.modified;

      const DepsSortPerformer(params).perform();

      expect(lastModifiedBefore.isBefore(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForSortingFlippedNodesPath path', () {
    const sourcePath = meantForSortingFlippedNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will sort all dependencies', () {
      const params = DepsSortParams(path: sourcePath);

      final result = const DepsSortPerformer(params).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });

  group('providing $meantForSortingNoNodesPath path', () {
    const sourcePath = meantForSortingNoNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will not sort anything', () {
      const params = DepsSortParams(path: sourcePath);

      final result = const DepsSortPerformer(params).perform();

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will not modify file', () async {
      const params = DepsSortParams(path: sourcePath);
      final lastModifiedBefore = sourceFile.modified;

      const DepsSortPerformer(params).perform();

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  test('providing $noDependenciesPath path will not do anything', () {
    const sourcePath = meantForSortingNoNodesPath;
    const params = DepsSortParams(path: sourcePath);
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final lastModifiedBefore = sourceFile.modified;

    final result = const DepsSortPerformer(params).perform();

    expect(result, isFalse);
    expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
  });
}
