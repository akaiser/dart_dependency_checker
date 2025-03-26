import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_params.dart';
import 'package:dart_dependency_checker/src/deps_used/deps_used_results.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';

/// Checks used dependencies via imports only.
class DepsUsedChecker extends Performer<DepsUsedParams, DepsUsedResults> {
  const DepsUsedChecker(super.params);

  @override
  DepsUsedResults perform() {
    final yamlFile = YamlFileFinder.from(params.path);
    final ownReference = YamlMapLoader.from(yamlFile).name;

    return DepsUsedResults(
      mainDependencies: _packages(
        DependencyType.mainDependencies,
        {
          ...params.mainIgnores,
          if (ownReference != null) ownReference,
        },
      ),
      devDependencies: _packages(
        DependencyType.devDependencies,
        {
          ...params.devIgnores,
          if (ownReference != null) ownReference,
        },
      ),
    );
  }

  Set<String> _packages(DependencyType dependencyType, Set<String> ignores) =>
      DartFiles.from(params.path, dependencyType)
          .expand((file) => DartFiles.packages(file))
          .where((package) => !ignores.contains(package))
          .sort()
          .unmodifiable;
}
