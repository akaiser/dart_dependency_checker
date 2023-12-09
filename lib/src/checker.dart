import 'dart:io';

import 'package:pubspec_yaml/pubspec_yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

PubspecYaml? getPubspecYaml(String testDirectory) {
  final yamlFile = File('$testDirectory/pubspec.yaml');
  if (yamlFile.existsSync()) {
    return yamlFile.readAsStringSync().toPubspecYaml();
  }
  return null;
}

Iterable<String> findUnusedDependencies(
  String testDirectory,
  PubspecYaml pubspecYaml,
) {
  final packages = _findPackages(pubspecYaml);
  if (packages.isNotEmpty) {
    final dartFiles = _dartFiles('$testDirectory/lib');
    if (dartFiles.isNotEmpty) {
      final packageUsageCount = {for (var package in packages) package: 0};

      for (var dartFile in dartFiles) {
        _packageImports(dartFile).forEach((package) {
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

Iterable<String> _packageImports(File file) => file
    .readAsLinesSync()
    .where((line) => line.startsWith('import \'package:'))
    .map((import) => _importPackageExp.firstMatch(import)?[1])
    .nonNulls;

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

Iterable<String> _findPackages(PubspecYaml pubspecYaml) =>
    pubspecYaml.dependencies.map((dependency) => dependency.package());
