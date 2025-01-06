import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:test/test.dart';

void main() {
  test('has known value counts', () {
    expect(DependencyType.values, hasLength(2));
  });

  const <DependencyType, String>{
    DependencyType.mainDependencies: 'dependencies',
    DependencyType.devDependencies: 'dev_dependencies',
  }.forEach((dependencyType, yamlNode) {
    test(
      '$dependencyType maps to expected "$yamlNode" yamlNode',
      () => expect(dependencyType.yamlNode, yamlNode),
    );
  });

  const <DependencyType, Set<String>>{
    DependencyType.mainDependencies: {'lib'},
    DependencyType.devDependencies: {'test', 'integration_test'},
  }.forEach((dependencyType, sourceDirectories) {
    test(
      '$dependencyType maps to expected "$sourceDirectories" sourceDirectories',
      () => expect(dependencyType.sourceDirectories, sourceDirectories),
    );
  });
}
