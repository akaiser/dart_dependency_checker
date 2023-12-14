enum CheckerMode {
  depOrigin._('dep-origin'),
  depsUnused._('deps-unused'),
  transitiveUse._('transitive-use');

  const CheckerMode._(this.name);

  final String name;
}

extension CheckerModeListExt on List<CheckerMode> {
  String get commaSeparated => map((e) => e.name).join(', ');
}
