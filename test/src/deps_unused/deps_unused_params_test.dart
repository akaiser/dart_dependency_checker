import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const DepsUnusedParams(path: 'any').props,
      hasLength(4),
    );
  });

  test('sets default values', () {
    const params = DepsUnusedParams(path: 'any');

    expect(params.devIgnores, const <String>{});
    expect(params.mainIgnores, const <String>{});
    expect(params.fix, isFalse);
  });
}
