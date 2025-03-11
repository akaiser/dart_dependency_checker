import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:test/test.dart';

void main() {
  const tested = DepsAddParams(path: 'any', main: {'a', 'b'}, dev: {'c', 'd'});

  test('has props', () {
    expect(tested.props, const [
      'any',
      {'a', 'b'},
      {'c', 'd'},
    ]);
  });

  test('sets values', () {
    expect(tested.main, const {'a', 'b'});
    expect(tested.dev, const {'c', 'd'});
  });
}
