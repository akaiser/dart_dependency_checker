import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:yaml/yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

class DepsUnusedChecker {
  const DepsUnusedChecker(this.path, this.pubspecYaml, this.devIgnores);

  final String path;
  final YamlMap pubspecYaml;
  final Set<String> devIgnores;

  DepsUnusedResults makeItSo() => DepsUnusedResults(
        dependencies: _unusedPackages(
          DependencyType.dependencies,
          const {},
        ),
        devDependencies: _unusedPackages(
          DependencyType.devDependencies,
          devIgnores,
        ),
      );

  Set<String> _unusedPackages(
    DependencyType dependencyType,
    Set<String> ignores,
  ) {
    final packages = _packages(dependencyType.yamlNode).difference(ignores);
    if (packages.isNotEmpty) {
      final dartFiles = dependencyType.sourceDirectories.fold(
        <File>{},
        (init, directory) => {...init, ..._dartFiles('$path/$directory')},
      );

      if (dartFiles.isNotEmpty) {
        final packageUsageCount = {for (final package in packages) package: 0};

        for (var dartFile in dartFiles) {
          _imports(dartFile).forEach((package) {
            final count = packageUsageCount[package];
            if (count != null) {
              packageUsageCount[package] = count + 1;
            }
          });
        }

        return packageUsageCount.entries
            .where((entry) => entry.value == 0)
            .map((entry) => entry.key)
            .toSet();
      }
    }

    return const {};
  }

  Set<String> _packages(String yamlNode) {
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

  Set<String> _imports(File file) => file
      .readAsLinesSync()
      .where((line) => line.startsWith('import \'package:'))
      .map((import) => _importPackageExp.firstMatch(import)?[1])
      .nonNulls
      .toSet();
}
