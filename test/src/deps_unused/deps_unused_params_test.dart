import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const DepsUnusedParams(path: 'any').props,
      hasLength(3),
    );
  });

  test('sets default values', () {
    const params = DepsUnusedParams(path: 'any');

    expect(params.devIgnores, const <String>{});
    expect(params.mainIgnores, const <String>{});
  });

  test('maps from $ArgumentsResult', () {
    const arguments = ArgumentsResult(
      mode: CheckerMode.depsUnused,
      path: 'any',
      devIgnores: {'some_dev'},
      mainIgnores: {'some_main'},
    );

    final params = DepsUnusedParams.from(arguments);

    expect(params.path, arguments.path);
    expect(params.devIgnores, arguments.devIgnores);
    expect(params.mainIgnores, arguments.mainIgnores);
  });
}
