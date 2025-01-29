import 'package:dart_dependency_checker/src/deps_used/deps_used_results.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    const results = DepsUsedResults(
      mainDependencies: {},
      devDependencies: {},
    );

    expect(results.props, hasLength(2));
  });
}
