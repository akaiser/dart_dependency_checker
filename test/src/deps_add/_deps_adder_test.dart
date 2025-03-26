import 'dart:io';

import 'package:dart_dependency_checker/src/deps_add/_deps_adder.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
  group('providing $meantForAddingPath path', () {
    const sourcePath = meantForAddingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will add all dependencies', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {
            'equatable:^2.0.7',
            'yaml: 3.1.3',
            'some_path_source :path= ../some_path_dependency',
            'some_git_source: git=https://github.com/munificent/kittens.git',
          },
          dev: {
            'test: ^1.16.0',
            'build_runner: 2.4.15',
          },
        ),
        sourceFile,
      );

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will modify file if something was removed', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {
            'equatable:^2.0.7',
            'yaml: 3.1.3',
            'some_path_source :path= ../some_path_dependency',
            'some_git_source: git=https://github.com/munificent/kittens.git',
          },
          dev: {
            'test: ^1.16.0',
            'build_runner: 2.4.15',
          },
        ),
        sourceFile,
      );

      expect(lastModifiedBefore.isBefore(sourceFile.modified), isTrue);
    });

    test('will not modify file if nothing was added', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        sourceFile,
      );

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForAddingFlippedNodesPath path', () {
    const sourcePath = meantForAddingFlippedNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will add all dependencies', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {
            'equatable:^2.0.7',
            'yaml: 3.1.3',
            'some_path_source :path= ../some_path_dependency',
            'some_git_source: git=https://github.com/munificent/kittens.git',
          },
          dev: {
            'test: ^1.16.0',
            'build_runner: 2.4.15',
          },
        ),
        sourceFile,
      );

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });

  group('providing $meantForAddingNewLinesPath path', () {
    const sourcePath = meantForAddingNewLinesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('adds and cleanes too many new lines', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        sourceFile,
      );

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('no change when nothing added', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        sourceFile,
      );

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected_no_change.yaml'.read,
      );
    });
  });

  group('providing $meantForAddingNewLinesEofPath path', () {
    const sourcePath = meantForAddingNewLinesEofPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('adds and cleanes too many eof new lines', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        sourceFile,
      );

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('no change when nothing added', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        sourceFile,
      );

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected_no_change.yaml'.read,
      );
    });
  });

  group('providing $meantForAddingNoNodesPath path', () {
    const sourcePath = meantForAddingNoNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will not add anything', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        sourceFile,
      );

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will not modify file', () async {
      final lastModifiedBefore = sourceFile.modified;

      DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        sourceFile,
      );

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForAddingSdkSourcePath path', () {
    const sourcePath = meantForAddingSdkSourcePath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('places SDK deps on top', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {
            'meta: ^1.11.0',
            'equatable: ^2.0.7',
            'flutter: sdk=flutter',
            'flutter_localizations: sdk=flutter',
          },
          dev: {
            'test: ^1.25.0',
            'mocktail: ^1.0.0',
            'flutter_test: sdk=flutter',
            'integration_test: sdk=flutter',
          },
        ),
        sourceFile,
      );

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });
}
