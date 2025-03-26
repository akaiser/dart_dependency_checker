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
import 'package:yaml/yaml.dart';

/// Checks via pubspec.yaml declared but unused dependencies.
class DepsUnusedChecker extends Performer<DepsUnusedParams, DepsUnusedResults> {
  const DepsUnusedChecker(super.params);

  @override
  DepsUnusedResults perform() {
    final yamlFile = YamlFileFinder.from(params.path);
    final yamlMap = YamlMapLoader.from(yamlFile);

    final results = DepsUnusedResults(
      mainDependencies: _unusedPackages(
        yamlMap,
        DependencyType.mainDependencies,
        params.mainIgnores,
      ),
      devDependencies: _unusedPackages(
        yamlMap,
        DependencyType.devDependencies,
        params.devIgnores,
      ),
    );

    if (!results.isEmpty && params.fix) {
      DepsCleaner.clean(results, yamlFile);
    }

    return results;
  }

  Set<String> _unusedPackages(
    YamlMap yamlMap,
    DependencyType dependencyType,
    Set<String> ignores,
  ) {
    final packages = yamlMap.packages(dependencyType).difference(ignores);

    if (packages.isEmpty) {
      return const {};
    }

    final files = DartFiles.from(params.path, dependencyType);

    if (files.isEmpty) {
      return packages;
    }

    return _packageUsageCount(packages, files)
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
