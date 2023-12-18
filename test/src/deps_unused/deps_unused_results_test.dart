import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:test/test.dart';

void main() {
  test('has known props count', () {
    const results = DepsUnusedResults(dependencies: {}, devDependencies: {});

    expect(results.props, hasLength(2));
  });

  group('isEmpty', () {
    test('is true when all dependencies are empty', () {
      const results = DepsUnusedResults(dependencies: {}, devDependencies: {});

      expect(results.isEmpty, isTrue);
    });

    test('is false when dependencies contains at least one entry', () {
      const results = DepsUnusedResults(
        dependencies: {'any'},
        devDependencies: {},
      );

      expect(results.isEmpty, isFalse);
    });

    test('is false when devDependencies contains at least one entry', () {
      const results = DepsUnusedResults(
        dependencies: {},
        devDependencies: {'any'},
      );

      expect(results.isEmpty, isFalse);
    });

    test('is false when both dependencies contain at least one entry', () {
      const results = DepsUnusedResults(
        dependencies: {'any'},
        devDependencies: {'any'},
      );

      expect(results.isEmpty, isFalse);
    });
  });
}
