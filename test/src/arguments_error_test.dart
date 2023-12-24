import 'package:dart_dependency_checker/src/arguments_error.dart';
import 'package:test/test.dart';

void main() {
  const error = ArgumentsError('some message');

  test('has known props count', () {
    expect(error.props, hasLength(1));
  });
}
