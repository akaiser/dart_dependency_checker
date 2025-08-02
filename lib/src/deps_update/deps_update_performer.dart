import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/deps_update/deps_update_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/deps_adder.dart';
import 'package:dart_dependency_checker/src/util/deps_cleaner.dart';
import 'package:dart_dependency_checker/src/util/deps_validation_ext.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/package_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';

/// Updates provided but only existing main and dev dependencies in a
/// pubspec.yaml file.
///
/// For simplicity:
/// - Doesn't care if a dependency is already up-to-date.
/// - First removes all valid dependencies provided in the params.
/// - Adds back only affected dependencies back to the file.
/// - For sure reshuffles the order of dependencies in the file.
/// - It is recommended to run the [DepsSortPerformer] afterwards.
///
/// Throws [InvalidParamsError] if any dependency in provided `params`
/// does not comply with the expected format.
/// Throws [PerformerError] if the pubspec.yaml file path is invalid.
///
/// Returns `true` if at least one dependency was updated.
class DepsUpdatePerformer extends Performer<DepsUpdateParams, bool> {
  const DepsUpdatePerformer(super.params);

  @override
  bool perform() {
    final mainPackages = (params.main..validate()).toPackages;
    final devPackages = (params.dev..validate()).toPackages;

    if (mainPackages.isNotEmpty || devPackages.isNotEmpty) {
      final yamlFile = YamlFileFinder.from(params.path);

      // Remove any existing dependency provided in the params.
      final removedDependencies = DepsCleaner.clean(
        yamlFile,
        mainDependencies: mainPackages.packageNames,
        devDependencies: devPackages.packageNames,
      );

      // Add only affected dependencies back to the file.
      return DepsAdder.add(
        yamlFile,
        mainPackages: mainPackages.whereFrom(removedDependencies),
        devPackages: devPackages.whereFrom(removedDependencies),
      );
    }

    return false;
  }
}

extension on Set<Package> {
  Set<String> get packageNames => map((package) => package.name).unmodifiable;

  Set<Package> whereFrom(Set<String> packageNames) =>
      where((package) => packageNames.contains(package.name)).unmodifiable;
}
