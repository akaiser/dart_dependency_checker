import 'dart:io';

import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/_shared/package_ext.dart';
import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_sort/_deps_parser.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_utils.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_map_loader.dart';

/// Sorts main and dev dependencies in a pubspec.yaml file.
///
/// For simplicity:
/// - Sorts packages alphabetically.
/// - Places packages by source order: sdk, hosted and rest.
/// - Will remove all comments and extra new lines.
/// - Doesn't know anything about `dependency_overrides` node.
abstract final class DepsSorter {
  /// Reads passed `yamlFile`, sorts dependencies and overrides file contents.
  ///
  /// Returns `true` on any change.
  static bool sort(File yamlFile) {
    final yamlMap = YamlMapLoader.from(yamlFile);

    final mainYamlMap = yamlMap.node(DependencyType.mainDependencies);
    final devYamlMap = yamlMap.node(DependencyType.devDependencies);

    final mainPackages = mainYamlMap != null //
        ? DepsParser.parse(mainYamlMap)
        : <Package>{};
    final devPackages = devYamlMap != null //
        ? DepsParser.parse(devYamlMap)
        : <Package>{};

    if (mainPackages.isEmpty && devPackages.isEmpty) {
      return false;
    }

    final contents = StringBuffer();

    var insideDependenciesNode = false;
    var insideDevDependenciesNode = false;

    final originalContent = yamlFile.readAsStringSync();
    final lines = yamlFile.readAsLinesSync();

    for (final line in lines) {
      final onMainDependencyNode = line.startsWith('$mainDependenciesNode:');
      final onDevDependencyNode = line.startsWith('$devDependenciesNode:');

      // found main node
      if (onMainDependencyNode) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          _add(contents, devPackages);
        }

        insideDependenciesNode = true;
        insideDevDependenciesNode = false;
        contents.writeln(line);
        continue;
      }
      // found dev node
      else if (onDevDependencyNode) {
        // maybe we were inside main node previously
        if (insideDependenciesNode) {
          _add(contents, mainPackages);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = true;
        contents.writeln(line);
        continue;
      }
      // found some other node
      else if (rootNodeExp.hasMatch(line)) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          _add(contents, devPackages);
        } else if (insideDependenciesNode) {
          _add(contents, mainPackages);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      // skip original deps contents
      if (insideDependenciesNode || insideDevDependenciesNode) {
        continue;
      }

      contents.writeln(line);
    }

    // no other unrelated node was found, ensure to finish deps adding
    if (insideDevDependenciesNode) {
      _add(contents, devPackages);
    } else if (insideDependenciesNode) {
      _add(contents, mainPackages);
    }

    var newContent = contents.toString();

    if (originalContent.trim() != newContent.trim()) {
      // and we are still inside main or dev node
      if (insideDependenciesNode || insideDevDependenciesNode) {
        // ensuring no extra eof new lines are left
        newContent = newContent.trimRight().newLine;
      }
      yamlFile.writeAsStringSync(newContent);
      return true;
    }

    return false;
  }

  static void _add(StringBuffer contents, Iterable<Package> packages) {
    if (packages.isNotEmpty) {
      final sortedPackages = packages.sort().unmodifiable;

      final sdkPackages = sortedPackages.whereType<SdkPackage>();
      final hostedPackages = sortedPackages.whereType<HostedPackage>();
      final rest = sortedPackages.where(
        (p) => p is! SdkPackage && p is! HostedPackage,
      );

      _addSection(contents, sdkPackages);
      _addSection(contents, hostedPackages);
      _addSection(contents, rest);
    } else {
      // leave new line in empty dependency node
      contents.writeln();
    }
  }

  static void _addSection(StringBuffer contents, Iterable<Package> packages) {
    if (packages.isNotEmpty) {
      for (final package in packages) {
        contents.writeln(package.pubspecEntry);
      }
      contents.writeln();
    }
  }
}
