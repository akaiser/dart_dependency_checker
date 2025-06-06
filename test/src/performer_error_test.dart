import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:test/test.dart';

void main() {
  group('$PubspecNotFoundError', () {
    const error = PubspecNotFoundError('some_path');

    test('has known props count', () {
      expect(error.props, hasLength(1));
    });

    test('creates message', () {
      expect(error.message, 'Invalid pubspec.yaml file path: some_path');
    });
  });

  group('$PubspecNotValidError', () {
    const error = PubspecNotValidError('some_path');

    test('has known props count', () {
      expect(error.props, hasLength(1));
    });

    test('creates message', () {
      expect(error.message, 'Invalid pubspec.yaml file contents in: some_path');
    });
  });

  group('$InvalidParamsError', () {
    const error = InvalidParamsError('some details');

    test('has known props count', () {
      expect(error.props, hasLength(1));
    });

    test('creates message', () {
      expect(error.message, 'Invalid params near: "some details"');
    });
  });
}
