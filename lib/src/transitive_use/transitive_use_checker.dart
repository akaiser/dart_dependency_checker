import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_file_loader.dart';

/// Checks direct use of pubspec.yaml undeclared aka. transitive dependencies.
class TransitiveUseChecker
    extends Performer<TransitiveUseParams, TransitiveUseResults> {
  const TransitiveUseChecker(super.params);

  @override
  TransitiveUseResults perform() {
    final yamlMap = YamlMapFileLoader.from(params.path).yamlMap;
    final ownReference = yamlMap.name;

    final declaredMainDependencies = yamlMap.packages(
      DependencyType.mainDependencies,
    );

    return TransitiveUseResults(
      mainDependencies: _find(
        DependencyType.mainDependencies,
        {
          ...params.mainIgnores,
          if (ownReference != null) ownReference,
        },
        (_) => declaredMainDependencies,
      ),
      devDependencies: _find(
        DependencyType.devDependencies,
        {
          ...params.devIgnores,
          ...declaredMainDependencies,
          if (ownReference != null) ownReference,
        },
        (dependencyType) => yamlMap.packages(dependencyType),
      ),
    );
  }

  Set<String> _find(
    DependencyType dependencyType,
    Set<String> ignores,
    Set<String> Function(DependencyType) declaredDependencies,
  ) =>
      DartFiles.from(params.path, dependencyType)
          .map((file) => DartFiles.packages(file))
          .expand((packages) => packages)
          .unmodifiable
          .difference(declaredDependencies(dependencyType))
          .difference(ignores..nonNulls);
}
