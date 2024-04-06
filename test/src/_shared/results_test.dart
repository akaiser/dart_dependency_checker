import 'package:dart_dependency_checker/src/_shared/results.dart';
import 'package:test/test.dart';

class _BaseResults extends BaseResults {
  const _BaseResults({
    required super.mainDependencies,
    required super.devDependencies,
  });
}

void main() {
  test('has known props count', () {
    const results = _BaseResults(
      mainDependencies: {},
      devDependencies: {},
    );

    expect(results.props, hasLength(2));
  });

  group('isEmpty', () {
    test('is true when all dependencies are empty', () {
      const results = _BaseResults(
        mainDependencies: {},
        devDependencies: {},
      );

      expect(results.isEmpty, isTrue);
    });

    test('is false when dependencies contains at least one entry', () {
      const results = _BaseResults(
        mainDependencies: {'any'},
        devDependencies: {},
      );

      expect(results.isEmpty, isFalse);
    });

    test('is false when devDependencies contains at least one entry', () {
      const results = _BaseResults(
        mainDependencies: {},
        devDependencies: {'any'},
      );

      expect(results.isEmpty, isFalse);
    });

    test('is false when both dependencies contain at least one entry', () {
      const results = _BaseResults(
        mainDependencies: {'any'},
        devDependencies: {'any'},
      );

      expect(results.isEmpty, isFalse);
    });
  });
}
