import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';

const allSourcesDirsPath = 'test/resources/deps_unused/all_sources_dirs';
const emptyPubspecYamlPath = 'test/resources/deps_unused/empty_pubspec_yaml';
const noDependenciesPath = 'test/resources/deps_unused/no_dependencies';
const noSourcesDirsPath = 'test/resources/deps_unused/no_sources_dirs';

DepsUnusedParams params(
  String path, [
  Set<String> devIgnores = const {},
]) =>
    DepsUnusedParams(
      path: path,
      devIgnores: devIgnores,
    );
