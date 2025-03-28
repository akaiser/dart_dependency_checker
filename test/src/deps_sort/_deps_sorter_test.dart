import 'dart:io';

import 'package:dart_dependency_checker/src/deps_sort/_deps_sorter.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
  group('providing $meantForSortingPath path', () {
    const sourcePath = meantForSortingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will sort all dependencies', () {
      final result = DepsSorter.sort(sourceFile);

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will modify file', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsSorter.sort(sourceFile);

      expect(lastModifiedBefore.isBefore(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForSortingFlippedNodesPath path', () {
    const sourcePath = meantForSortingFlippedNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will sort all dependencies', () {
      final result = DepsSorter.sort(sourceFile);

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
      final result = DepsSorter.sort(sourceFile);

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will not modify file', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsSorter.sort(sourceFile);

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  test('providing $noDependenciesPath path will not do anything', () {
    final sourceFile = File('$noDependenciesPath/pubspec.yaml');
    final lastModifiedBefore = sourceFile.modified;

    final result = DepsSorter.sort(sourceFile);

    expect(result, isFalse);
    expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
  });
}
