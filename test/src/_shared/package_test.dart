import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:test/test.dart';

void main() {
  test('$HostedPackage has known props count', () {
    const tested = HostedPackage('package_name', '1.0.0');

    expect(tested.props, hasLength(2));
  });

  test('$PathPackage has known props count', () {
    const tested = PathPackage('package_name', 'path/to/package');

    expect(tested.props, hasLength(2));
  });

  test('$SdkPackage has known props count', () {
    const tested = SdkPackage('package_name', 'flutter');

    expect(tested.props, hasLength(2));
  });

  test('$GitPackage has known props count', () {
    const tested = GitPackage(
      'package_name',
      'url',
      ref: 'ref',
      path: 'path',
    );

    expect(tested.props, hasLength(4));
  });
}
