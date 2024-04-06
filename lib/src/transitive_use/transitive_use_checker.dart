import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_params.dart';
import 'package:dart_dependency_checker/src/transitive_use/transitive_use_results.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_loader.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:yaml/yaml.dart';

/// Checks direct use of undeclared/transitive dependencies.
class TransitiveUseChecker
    extends Checker<TransitiveUseParams, TransitiveUseResults> {
  const TransitiveUseChecker(super.params);

  @override
  TransitiveUseResults check() {
    final pubspecYaml = PubspecYamlLoader.from(params.path);

    return TransitiveUseResults(
      mainDependencies: _find(
        pubspecYaml,
        DependencyType.mainDependencies,
        params.mainIgnores,
      ),
      devDependencies: _find(
        pubspecYaml,
        DependencyType.devDependencies,
        params.devIgnores,
      ),
    );
  }

  Set<String> _find(
    YamlMap pubspecYaml,
    DependencyType dependencyType,
    Set<String> ignores,
  ) =>
      DartFiles.from(params.path, dependencyType)
          .map((file) => DartFiles.packages(file))
          .expand((packages) => packages)
          .toSet()
          .difference(pubspecYaml.packages(dependencyType))
          .difference(ignores);
}
