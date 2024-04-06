import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    const results = TransitiveUseResults(
      mainDependencies: {},
      devDependencies: {},
    );

    expect(results.props, hasLength(2));
  });
}
