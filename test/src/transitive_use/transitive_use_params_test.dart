import 'package:dart_dependency_checker/dart_dependency_checker.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    expect(
      const TransitiveUseParams(path: 'any').props,
      hasLength(3),
    );
  });
}
