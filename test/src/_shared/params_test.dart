import 'package:dart_dependency_checker/src/_shared/params.dart';
import 'package:test/test.dart';

class _PathParam extends PathParam {
  const _PathParam({required super.path});
}

class _PathWithIgnoresParams extends PathWithIgnoresParams {
  const _PathWithIgnoresParams({
    required super.path,
    super.mainIgnores,
    super.devIgnores,
  });
}

void main() {
  group('$PathParam', () {
    const tested = _PathParam(path: 'any');

    test('has props', () {
      expect(tested.props, const ['any']);
    });
  });

  group('$PathWithIgnoresParams', () {
    test('has props', () {
      const tested = _PathWithIgnoresParams(
        path: 'any',
        mainIgnores: {'a', 'b'},
        devIgnores: {'c', 'd'},
      );

      expect(tested.props, const [
        'any',
        {'a', 'b'},
        {'c', 'd'},
      ]);
    });

    test('sets values', () {
      const tested = _PathWithIgnoresParams(
        path: 'any',
        mainIgnores: {'a', 'b'},
        devIgnores: {'c', 'd'},
      );

      expect(tested.mainIgnores, const {'a', 'b'});
      expect(tested.devIgnores, const {'c', 'd'});
    });

    test('sets default values', () {
      const tested = _PathWithIgnoresParams(path: 'any');

      expect(tested.mainIgnores, const <String>{});
      expect(tested.devIgnores, const <String>{});
    });
  });
}
