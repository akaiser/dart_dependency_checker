import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const DepsUnusedParams(path: 'any', devIgnores: {'some'}).props,
      hasLength(2),
    );
  });

  test('"from" maps from $ArgumentsResult', () {
    const arguments = ArgumentsResult(
      mode: CheckerMode.depsUnused,
      path: 'any',
      devIgnores: {'some'},
    );

    final params = DepsUnusedParams.from(arguments);

    expect(params.path, arguments.path);
    expect(params.devIgnores, arguments.devIgnores);
  });
}
