import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

final _importPackageExp = RegExp(r':(.*?)/');

void checkUnused(List<String> arguments, Console console) {
  final testDirectory =
      arguments.isNotEmpty ? arguments[0] : Directory.current.path;

  final yamlFile = File('$testDirectory/pubspec.yaml');
  if (!yamlFile.existsSync()) {
    console.writeErrorLine(
      'Invalid pubspec.yml path: ${yamlFile.path}',
    );
    exit(2);
  }

  final pubspecYaml = yamlFile.readAsStringSync().toPubspecYaml();

  final packages = _findPackages(pubspecYaml);
  if (packages.isEmpty) {
    console.writeLine('Nothing to do, no packages!');
    return;
  }

  final dartFiles = _findDartFiles('$testDirectory/lib');
  if (dartFiles.isEmpty) {
    console.writeLine('Nothing to do, no lib dart files!');
    return;
  }

  // init package usage counts
  final packageUsageCount = {for (var package in packages) package: 0};

  for (var dartFile in dartFiles) {
    _findPackageImports(dartFile).forEach((package) {
      final count = packageUsageCount[package];
      if (count != null) {
        packageUsageCount[package] = count + 1;
      }
    });
  }

  final unusedPackages = packageUsageCount.entries
      .where((entry) => entry.value == 0)
      .map((entry) => entry.key);

  if (unusedPackages.isNotEmpty) {
    console.writeErrorLine('# Unused "dependencies" packages #');
    console.writeErrorLine(yamlFile.absolute);
    unusedPackages.forEach(console.writeErrorLine);
    console.writeErrorLine('##################################');
    exit(2);
  }
  console.writeLine('All good!');
}

Iterable<String> _findPackageImports(File file) => file
    .readAsLinesSync()
    .where((line) => line.startsWith('import \'package:'))
    .map((import) => _importPackageExp.firstMatch(import)?[1])
    .nonNulls;

Iterable<File> _findDartFiles(String path) => Directory(path)
    .listSync(recursive: true, followLinks: false)
    .where((file) => file is File && file.path.endsWith('.dart'))
    .map((file) => file as File);

Iterable<String> _findPackages(PubspecYaml pubspecYaml) =>
    pubspecYaml.dependencies.map((dependency) => dependency.package());
