import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:test/test.dart';

void main() {
  group('unmodifiable', () {
    final tested = const {1, 2, 3}.unmodifiable;

    test('creates list', () {
      expect(tested, isA<Set<int>>());
    });

    test('equals', () {
      expect(tested, equals(const {1, 2, 3}));
    });

    test('is not same', () {
      expect(tested, isNot(same(const {1, 2, 3})));
    });

    test('throws on add', () {
      expect(() => tested.add(0), throwsUnsupportedError);
    });

    test('throws on remove', () {
      expect(() => tested.remove(0), throwsUnsupportedError);
    });
  });

  group('sort', () {
    test('sorts set', () {
      const Set<int> tested = {3, 1, 2};

      expect(tested.sort(), const {1, 2, 3});
    });

    test('sorts iterable', () {
      const Iterable<String> tested = ['banana', 'apple', 'cherry', 'apple'];

      expect(tested.sort(), const ['apple', 'apple', 'banana', 'cherry']);
    });

    test('sorts with custom comparator', () {
      const tested = {3, 1, 2};

      expect(tested.sort((a, b) => b.compareTo(a)), const [3, 2, 1]);
    });

    test('returns empty when sorting empty', () {
      const list = <String>{};

      expect(list.sort(), const <String>{});
    });
  });
}
