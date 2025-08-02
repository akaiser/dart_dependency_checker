import 'package:dart_dependency_checker/src/deps_update/deps_update_params.dart';
import 'package:dart_dependency_checker/src/deps_update/deps_update_performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_file_arrange_builder.dart';
import '../_paths.dart';

void main() {
  test(
      'throws a $PerformerError with proper message '
      'on invalid pubspec.yaml path', () {
    expect(
      const DepsUpdatePerformer(
        DepsUpdateParams(
          path: 'unknown',
          main: {'test: 1.0.0'},
        ),
      ).perform,
      throwsA(
        isA<PerformerError>().having(
          (e) => e.message,
          'message',
          'Invalid pubspec.yaml file path: unknown/pubspec.yaml',
        ),
      ),
    );
  });

  group(
      'throws a $InvalidParamsError with proper message '
      'when failing on validation', () {
    const sourcePath = noDependenciesPath;

    test('for main dependency', () {
      expect(
        const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'any_main'},
          ),
        ).perform,
        throwsA(
          isA<PerformerError>().having(
            (e) => e.message,
            'message',
            'Invalid params near: "any_main"',
          ),
        ),
      );
    });

    test('for dev dependency', () {
      expect(
        const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            dev: {'any_dev'},
          ),
        ).perform,
        throwsA(
          isA<PerformerError>().having(
            (e) => e.message,
            'message',
            'Invalid params near: "any_dev"',
          ),
        ),
      );
    });
  });

  group('performs', () {
    late FileArrangeBuilder builder;

    setUp(() => builder = FileArrangeBuilder());
    tearDown(() => builder.reset());

    group('providing $noNodesPath path', () {
      const sourcePath = noNodesPath;

      setUp(() => builder.init(sourcePath));

      test('will not update anything', () {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'equatable:^2.0.7'},
            dev: {'test: ^1.16.0'},
          ),
        ).perform();

        expect(result, isFalse);
        expect(builder.readFile, builder.readExpectedFile);
      });

      test('will not modify file', () async {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'equatable:^2.0.7'},
            dev: {'test: ^1.16.0'},
          ),
        ).perform();

        expect(result, isFalse);
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });
    });

    group('providing $noDependenciesPath path', () {
      const sourcePath = noDependenciesPath;

      setUp(() => builder.init(sourcePath));

      test('will not update anything', () {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'equatable:^2.0.7'},
            dev: {'test: ^1.16.0'},
          ),
        ).perform();

        expect(result, isFalse);
        expect(builder.readFile, builder.readExpectedFile);
      });

      test('will not modify file', () async {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'equatable:^2.0.7'},
            dev: {'test: ^1.16.0'},
          ),
        ).perform();

        expect(result, isFalse);
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });
    });

    group('providing $meantForUpdatingPath path', () {
      const sourcePath = meantForUpdatingPath;

      setUp(() => builder.init(sourcePath));

      test('will not modify file on not matching deps', () async {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {'equatable:^2.0.7'},
          ),
        ).perform();

        expect(result, isFalse);
        expect(
          builder.fileCreatedAt.isAtSameMomentAs(builder.fileModifiedAt),
          isTrue,
        );
      });

      test('will update all matching dependencies', () async {
        final result = const DepsUpdatePerformer(
          DepsUpdateParams(
            path: sourcePath,
            main: {
              'args:^2.7.0',
              'equatable:^2.0.7',
              'some_path_source : path= ../some_path_dependency/new',
              'some: git= https://any.git; ref=main',
            },
            dev: {'test: ^1.26.3'},
          ),
        ).perform();

        expect(result, isTrue);
        expect(builder.readFile, builder.readExpectedFile);
      });
    });
  });
}
