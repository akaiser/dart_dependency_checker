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

  group(
      'throws a $InvalidParamsError with proper message '
      'when failing on validation', () {
    const path = noDependenciesPath;

    test('for main dependency', () {
      expect(
        const DepsAddPerformer(
          DepsAddParams(
            path: path,
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
        const DepsAddPerformer(
          DepsAddParams(
            path: path,
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
}
