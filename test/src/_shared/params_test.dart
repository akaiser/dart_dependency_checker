import 'package:dart_dependency_checker/src/_shared/params.dart';
import 'package:test/test.dart';

class _BaseParams extends BaseParams {
  const _BaseParams({required super.path});
}

void main() {
  test('has known props count', () {
    expect(
      const _BaseParams(path: 'any').props,
      hasLength(3),
    );
  });

  test('sets default values', () {
    const params = _BaseParams(path: 'any');

    expect(params.mainIgnores, const <String>{});
    expect(params.devIgnores, const <String>{});
  });
}
