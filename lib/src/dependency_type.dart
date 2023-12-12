enum DependencyType {
  dependencies._('dependencies', {'lib'}),
  devDependencies._('dev_dependencies', {'test', 'integration_test'});

  const DependencyType._(
    this.yamlNode,
    this.sourceDirectories,
  );

  final String yamlNode;
  final Set<String> sourceDirectories;
}
