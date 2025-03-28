import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/_deps_cleaner.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';

/// Checks via pubspec.yaml declared but unused dependencies.
class DepsUnusedChecker extends Performer<DepsUnusedParams, DepsUnusedResults> {
  const DepsUnusedChecker(super.params);

  @override
  DepsUnusedResults perform() {
    final yamlFile = YamlFileFinder.from(params.path);
    final yamlMap = YamlMapLoader.from(yamlFile);

    final declaredInMain = yamlMap
        .packages(DependencyType.mainDependencies)
        .difference(params.mainIgnores);

    final declaredInDev = yamlMap
        .packages(DependencyType.devDependencies)
        .difference(params.devIgnores);

    final results = DepsUnusedResults(
      mainDependencies: _unusedPackages(
        DependencyType.mainDependencies,
        declaredInMain,
      ),
      devDependencies: {
        ..._unusedPackages(
          DependencyType.devDependencies,
          declaredInDev,
        ),
        // if any declared dev dep exists in main, mark it for removal from dev.
        ...declaredInMain.intersection(declaredInDev),
      },
    );

    if (!results.isEmpty && params.fix) {
      DepsCleaner.clean(results, yamlFile);
    }

    return results;
  }

  Set<String> _unusedPackages(
    DependencyType dependencyType,
    Set<String> declaredPackages,
  ) {
    if (declaredPackages.isEmpty) {
      return const {};
    }

    final files = DartFiles.from(params.path, dependencyType);

    if (files.isEmpty) {
      return declaredPackages;
    }

    return _packageUsageCount(declaredPackages, files)
        .entries
        .where((entry) => entry.value == 0)
        .map((entry) => entry.key)
        .unmodifiable;
  }

  Map<String, int> _packageUsageCount(Set<String> packages, Set<File> files) {
    final packageUsageCount = {for (final package in packages) package: 0};

    for (final file in files) {
      for (final package in DartFiles.packages(file)) {
        final count = packageUsageCount[package] ?? 0;
        packageUsageCount[package] = count + 1;
      }
    }
    return packageUsageCount;
  }
}
