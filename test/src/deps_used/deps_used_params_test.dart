import 'package:dart_dependency_checker/src/deps_used/deps_used_params.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const DepsUsedParams(path: 'any').props,
      hasLength(3),
    );
  });
}
