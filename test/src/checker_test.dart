import 'package:dart_dependency_checker/src/checker.dart';
import 'package:test/test.dart';

void main() {
  test('getPubspecYaml', () {
    expect(getPubspecYaml('.'), isNotNull);
  });
}
