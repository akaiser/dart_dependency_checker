import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    const results = DepsUnusedResults(
      mainDependencies: {},
      devDependencies: {},
    );

    expect(results.props, hasLength(2));
  });
}
