import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/unused_results.dart';
import 'package:yaml/yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

class Checker {
  const Checker(this.testDirectory, this.pubspecYaml);

  final String testDirectory;
  final YamlMap pubspecYaml;

  UnusedResults makeItSo() => UnusedResults(
        dependencies: _unusedPackages(DependencyType.dependencies),
        devDependencies: _unusedPackages(DependencyType.devDependencies),
      );

  Iterable<String> _unusedPackages(DependencyType dependencyType) {
    final packages = _packages(dependencyType.yamlNode);
    if (packages.isNotEmpty) {
      final dartFiles = _dartFiles(
        '$testDirectory/${dependencyType.sourceDirectory}',
      );
      if (dartFiles.isNotEmpty) {
        final packageUsageCount = {for (var package in packages) package: 0};

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
            .map((entry) => entry.key);
      }
    }

    return const [];
  }

  Iterable<String> _packages(String yamlNode) {
    final YamlMap? nodeValue = pubspecYaml.nodes[yamlNode]?.value;
    return nodeValue?.keys.map((e) => e) ?? const [];
  }

  Iterable<File> _dartFiles(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory
          .listSync(recursive: true, followLinks: false)
          .where((file) => file is File && file.path.endsWith('.dart'))
          .map((file) => file as File);
    }
    return const [];
  }

  Iterable<String> _imports(File file) => file
      .readAsLinesSync()
      .where((line) => line.startsWith('import \'package:'))
      .map((import) => _importPackageExp.firstMatch(import)?[1])
      .nonNulls;
}
