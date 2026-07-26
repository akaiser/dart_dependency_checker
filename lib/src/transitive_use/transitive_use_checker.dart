import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';

/// Checks direct use of pubspec.yaml undeclared aka. transitive dependencies.
class TransitiveUseChecker
    extends Performer<TransitiveUseParams, TransitiveUseResults> {
  const TransitiveUseChecker(super.params);

  @override
  TransitiveUseResults perform() {
    final yamlFile = YamlFileFinder.from(params.path);
    final yamlMap = YamlMapLoader.from(yamlFile);
    final ownReference = yamlMap.name;

    final declaredMainDependencies = yamlMap.packages(.mainDependencies);

    return TransitiveUseResults(
      mainDependencies: _find(.mainDependencies, {
        ...params.mainIgnores,
        ?ownReference,
      }, (_) => declaredMainDependencies),
      devDependencies: _find(.devDependencies, {
        ...params.devIgnores,
        ...declaredMainDependencies,
        ?ownReference,
      }, (dependencyType) => yamlMap.packages(dependencyType)),
    );
  }

  Set<String> _find(
    DependencyType dependencyType,
    Set<String> ignores,
    Set<String> Function(DependencyType) declaredDependencies,
  ) => DartFiles.from(params.path, dependencyType)
      .map((file) => DartFiles.packages(file))
      .expand((packages) => packages)
      .unmodifiable
      .difference(declaredDependencies(dependencyType))
      .difference(ignores..nonNulls);
}
