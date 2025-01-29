import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const TransitiveUseParams(path: 'any').props,
      hasLength(3),
    );
  });
}
