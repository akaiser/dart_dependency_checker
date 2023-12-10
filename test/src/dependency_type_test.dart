import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:test/test.dart';

void main() {
  test('has known value counts', () {
    expect(DependencyType.values, hasLength(2));
  });

  <DependencyType, String>{
    DependencyType.dependencies: 'dependencies',
    DependencyType.devDependencies: 'dev_dependencies',
  }.forEach((dependencyType, yamlNode) {
    test(
      '$dependencyType maps to expected "$yamlNode" yamlNode',
      () => expect(dependencyType.yamlNode, yamlNode),
    );
  });

  <DependencyType, String>{
    DependencyType.dependencies: 'lib',
    DependencyType.devDependencies: 'test',
  }.forEach((dependencyType, sourceDirectory) {
    test(
      '$dependencyType maps to expected "$sourceDirectory" sourceDirectory',
      () => expect(dependencyType.sourceDirectory, sourceDirectory),
    );
  });
}
