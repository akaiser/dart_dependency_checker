import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:test/test.dart';

void main() {
  group('unmodifiable', () {
    test('creates list', () {
      final Iterable<int> iterable = [1, 2, 3];

      final tested = iterable.unmodifiable;

      expect(tested, isA<List<int>>());
    });

    test('equals', () {
      final Iterable<int> iterable = [1, 2, 3];

      final tested = iterable.unmodifiable;

      expect(tested, equals(iterable));
    });

    test('is not same', () {
      final Iterable<int> iterable = [1, 2, 3];

      final tested = iterable.unmodifiable;

      expect(tested, isNot(same(iterable)));
    });

    test('throws on modification', () {
      final tested = [1, 2, 3].unmodifiable;

      expect(() => tested[0] = 42, throwsUnsupportedError);
    });
  });
}
