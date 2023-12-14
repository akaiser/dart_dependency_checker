import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:test/test.dart';

void main() {
  test('has known value counts', () {
    expect(CheckerMode.values, hasLength(3));
  });

  <CheckerMode, String>{
    CheckerMode.depOrigin: 'dep-origin',
    CheckerMode.depsUnused: 'deps-unused',
    CheckerMode.transitiveUse: 'transitive-use',
  }.forEach((checkerMode, name) {
    test('$checkerMode maps to expected "$name" name', () {
      expect(checkerMode.name, name);
    });
  });

  test('commaSeparated works expected', () {
    expect(
      CheckerMode.values.commaSeparated,
      'dep-origin, deps-unused, transitive-use',
    );
  });
}
