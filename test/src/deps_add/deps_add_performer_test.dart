import 'dart:io';

import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

import '../_paths.dart';

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
