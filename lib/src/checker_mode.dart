enum CheckerMode {
  debOrigin._('dep-origin'),
  depsUnused._('deps-unused'),
  transitiveUse._('transitive-use');

  const CheckerMode._(this.name);

  final String name;
}
