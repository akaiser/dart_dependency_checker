import 'dart:io';

import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_unused/deps_unused_results.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:yaml/yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

class DepsUnusedChecker extends Checker {
  const DepsUnusedChecker(
    super.logger,
    this.arguments,
    this.pubspecYaml,
  );

  final ArgumentsResult arguments;
  final YamlMap pubspecYaml;

  @override
  ExitCode makeItSo() {
    final results = DepsUnusedResults(
      dependencies: _unusedPackages(DependencyType.dependencies, const {}),
      devDependencies: _unusedPackages(
        DependencyType.devDependencies,
        arguments.devIgnores,
      ),
    );

    if (!results.isEmpty) {
      logger.warn('== Found unused packages ==');
      logger.warn('Path: ${arguments.path}/pubspec.yaml');
      _printDependencies('Dependencies', results.dependencies);
      _printDependencies('Dev Dependencies', results.devDependencies);
      return const ExitCode(1);
    }

    logger.info('All clear!');
    return ExitCode(exitCode);
  }

  Set<String> _unusedPackages(
    DependencyType dependencyType,
    Set<String> ignores,
  ) {
    final packages = _packages(dependencyType.yamlNode).difference(ignores);
    if (packages.isNotEmpty) {
      final dartFiles = dependencyType.sourceDirectories.fold(
        const <File>{},
        (init, directory) => {
          ...init,
          ..._dartFiles('${arguments.path}/$directory'),
        },
      );

      if (dartFiles.isEmpty) {
        return packages;
      }

      final packageUsageCount = {for (final package in packages) package: 0};

      for (final dartFile in dartFiles) {
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

  void _printDependencies(String label, Set<String> dependencies) {
    if (dependencies.isNotEmpty) {
      logger.warn('$label:');
      for (final dependency in dependencies) {
        logger.warn('  - $dependency');
      }
    }
  }
}
