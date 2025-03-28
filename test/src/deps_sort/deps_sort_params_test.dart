import 'package:dart_dependency_checker/src/deps_sort/deps_sort_params.dart';
import 'package:test/test.dart';

void main() {
  const tested = DepsSortParams(path: 'any');

  test('has props', () {
    expect(tested.props, const ['any']);
  });

  test('sets values', () {
    expect(tested.path, 'any');
  });
}
