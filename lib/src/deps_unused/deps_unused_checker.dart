import 'dart:io';

import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_fixer.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_loader.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:yaml/yaml.dart';

/// Checks via pubspec.yaml declared but unused dependencies.
class DepsUnusedChecker extends Checker<DepsUnusedParams, DepsUnusedResults> {
  const DepsUnusedChecker(super.params);

  @override
  DepsUnusedResults check() {
    final pubspecYaml = PubspecYamlLoader.from(params.path);

    final results = DepsUnusedResults(
      mainDependencies: _unusedPackages(
        pubspecYaml,
        DependencyType.mainDependencies,
        params.mainIgnores,
      ),
      devDependencies: _unusedPackages(
        pubspecYaml,
        DependencyType.devDependencies,
        params.devIgnores,
      ),
    );

    if (!results.isEmpty && params.fix) {
      DepsUnusedFixer.fix(results, params.path);
    }

    return results;
  }

  Set<String> _unusedPackages(
    YamlMap pubspecYaml,
    DependencyType dependencyType,
    Set<String> ignores,
  ) {
    final packages = pubspecYaml.packages(dependencyType).difference(ignores);

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
