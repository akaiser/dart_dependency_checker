import 'package:dart_dependency_checker/src/deps_add/_deps_adder.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';
import '../_util.dart';

void main() {
  late FileArrangeBuilder builder;

  setUp(() => builder = FileArrangeBuilder());

  tearDown(() => builder.reset());

  group('providing $meantForAddingPath path', () {
    const sourcePath = meantForAddingPath;

    setUp(() => builder.init(sourcePath));

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
        builder.file,
      );

      expect(result, isTrue);
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('will modify file if something was removed', () async {
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
        builder.file,
      );

      expect(
        builder.fileCreatedAt.isBefore(builder.fileModifiedAt),
        isTrue,
      );
    });

    test('will not modify file if nothing was added', () async {
      DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        builder.file,
      );

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });

  group('providing $meantForAddingFlippedNodesPath path', () {
    const sourcePath = meantForAddingFlippedNodesPath;

    setUp(() => builder.init(sourcePath));

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
        builder.file,
      );

      expect(result, isTrue);
      expect(builder.readFile, builder.readExpectedFile);
    });
  });

  group('providing $meantForAddingNewLinesPath path', () {
    const sourcePath = meantForAddingNewLinesPath;

    setUp(() => builder.init(sourcePath));

    test('adds and cleanes too many new lines', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        builder.file,
      );

      expect(result, isTrue);
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('no change when nothing added', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        builder.file,
      );

      expect(result, isFalse);
      expect(
        builder.readFile,
        '$sourcePath/expected_no_change.yaml'.read,
      );
    });
  });

  group('providing $meantForAddingNewLinesEofPath path', () {
    const sourcePath = meantForAddingNewLinesEofPath;

    setUp(() => builder.init(sourcePath));

    test('adds and cleanes too many eof new lines', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        builder.file,
      );

      expect(result, isTrue);
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('no change when nothing added', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {},
          dev: {},
        ),
        builder.file,
      );

      expect(result, isFalse);
      expect(
        builder.readFile,
        '$sourcePath/expected_no_change.yaml'.read,
      );
    });
  });

  group('providing $meantForAddingNoNodesPath path', () {
    const sourcePath = meantForAddingNoNodesPath;

    setUp(() => builder.init(sourcePath));

    test('will not add anything', () {
      final result = DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        builder.file,
      );

      expect(result, isFalse);
      expect(builder.readFile, builder.readExpectedFile);
    });

    test('will not modify file', () async {
      DepsAdder.add(
        const DepsAddParams(
          path: sourcePath,
          main: {'equatable:^2.0.7'},
          dev: {'test: ^1.16.0'},
        ),
        builder.file,
      );

      expect(
        builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
        isTrue,
      );
    });
  });

  group('providing $meantForAddingSdkSourcePath path', () {
    const sourcePath = meantForAddingSdkSourcePath;

    setUp(() => builder.init(sourcePath));

    test('places sdk deps anywhere', () {
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
        builder.file,
      );

      expect(result, isTrue);
      expect(builder.readFile, builder.readExpectedFile);
    });
  });
}
