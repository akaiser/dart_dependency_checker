import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:test/test.dart';

void main() {
  const result = ArgumentsResult(
    mode: CheckerMode.depsUnused,
    path: 'some_path',
    devIgnores: {'lints'},
    mainIgnores: {},
    fix: true,
  );

  test('has known props count', () {
    expect(result.props, hasLength(5));
  });
}
