enum DependencyType {
  dependencies._('dependencies', 'lib'),
  devDependencies._('dev_dependencies', 'test');

  const DependencyType._(
    this.yamlNode,
    this.sourceDirectory,
  );

  final String yamlNode;
  final String sourceDirectory;
}
