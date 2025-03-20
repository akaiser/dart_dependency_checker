import 'dart:io';

import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';
import '../_util.dart';

void main() {
  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsAddPerformer(DepsAddParams(path: 'unknown')).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  group('providing $meantForAddingPath path', () {
    const sourcePath = meantForAddingPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will add all dependencies', () {
      final result = const DepsAddPerformer(
        DepsAddParams(
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
      ).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will modify file if something was removed', () async {
      final lastModifiedBefore = sourceFile.modified;

      const DepsAddPerformer(
        DepsAddParams(
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
      ).perform();

      expect(lastModifiedBefore.isBefore(sourceFile.modified), isTrue);
    });

    test('will not modify file if nothing was added', () async {
      final lastModifiedBefore = sourceFile.modified;

      const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
      ).perform();

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForAddingFlippedNodesPath path', () {
    const sourcePath = meantForAddingFlippedNodesPath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('will add all dependencies', () {
      final result = const DepsAddPerformer(
        DepsAddParams(
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
      ).perform();

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
      final result = const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
      ).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('no change when nothing added', () {
      final result = const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
      ).perform();

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
      final result = const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
      ).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('no change when nothing added', () {
      final result = const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
      ).perform();

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
      final result = const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
      ).perform();

      expect(result, isFalse);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });

    test('will not modify file', () async {
      final lastModifiedBefore = sourceFile.modified;

      const DepsAddPerformer(
        DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
      ).perform();

      expect(lastModifiedBefore.isAtSameMomentAs(sourceFile.modified), isTrue);
    });
  });

  group('providing $meantForAddingSdkSourcePath path', () {
    const sourcePath = meantForAddingSdkSourcePath;
    final sourceFile = File('$sourcePath/pubspec.yaml');
    final sourceContent = sourceFile.read;

    tearDown(() => sourceFile.writeAsStringSync(sourceContent));

    test('places SDK deps on top', () {
      final result = const DepsAddPerformer(
        DepsAddParams(
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
      ).perform();

      expect(result, isTrue);
      expect(
        sourceFile.read,
        '$sourcePath/expected.yaml'.read,
      );
    });
  });
}
