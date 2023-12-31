import 'dart:io';

import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_fixer.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_params.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_reader.dart';
import 'package:yaml/yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

/// Checks declared but unused dependencies.
class DepsUnusedChecker extends Checker<DepsUnusedParams, DepsUnusedResults> {
  const DepsUnusedChecker(super.params);

  @override
  DepsUnusedResults check() {
    final pubspecYaml = PubspecYamlReader.from(params.path);

    final results = DepsUnusedResults(
      dependencies: _unusedPackages(
        pubspecYaml,
        DependencyType.dependencies,
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
    final packages = _packages(
      pubspecYaml,
      dependencyType.yamlNode,
    ).difference(ignores);

    if (packages.isNotEmpty) {
      final dartFiles = dependencyType.sourceDirectories.fold(
        const <File>{},
        (init, directory) => {
          ...init,
          ..._dartFiles('${params.path}/$directory'),
        },
      );

      if (dartFiles.isEmpty) {
        return packages;
      }

      return _packageUsageCount(packages, dartFiles)
          .entries
          .where((entry) => entry.value == 0)
          .map((entry) => entry.key)
          .toSet();
    }

    return const {};
  }

  Set<String> _packages(YamlMap pubspecYaml, String yamlNode) {
    final nodeValue = pubspecYaml.nodes[yamlNode]?.value as YamlMap?;
    return nodeValue?.keys.map((e) => e as String).toSet() ?? const {};
  }

  Set<File> _dartFiles(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory
          .listSync(recursive: true, followLinks: false)
          .where((file) => file is File && file.path.endsWith('.dart'))
          .map((file) => file as File)
          .toSet();
    }
    return const {};
  }

  Map<String, int> _packageUsageCount(
    Set<String> packages,
    Set<File> dartFiles,
  ) {
    final packageUsageCount = {for (final package in packages) package: 0};

    for (final dartFile in dartFiles) {
      _imports(dartFile).forEach((package) {
        final count = packageUsageCount[package] ?? 0;
        packageUsageCount[package] = count + 1;
      });
    }
    return packageUsageCount;
  }

  Set<String> _imports(File file) => file
      .readAsLinesSync()
      .where((line) => line.startsWith('import \'package:'))
      .map((import) => _importPackageExp.firstMatch(import)?[1])
      .nonNulls
      .toSet();
}
