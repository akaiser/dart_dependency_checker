import 'dart:io';

import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/_shared/package_ext.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_utils.dart';

/// Blindly adds main and dev dependencies to a pubspec.yaml file
/// (without consulting dart pub add).
///
/// For simplicity:
/// - Doesn't care if the dependency is already in the file.
/// - Doesn't care about the order of source type placement.
/// - Doesn't know anything about `dependency_overrides` node.
/// - Won't add a dependency if the main/dev node is missing.
abstract final class DepsAdder {
  /// Reads passed `yamlFile`, adds dependencies passed via [DepsAddParams]
  /// and overrides file contents.
  ///
  /// Returns `true` if at least one dependency was added.
  static bool add(DepsAddParams params, File yamlFile) {
    final contents = StringBuffer();

    var insideDependenciesNode = false;
    var insideDevDependenciesNode = false;
    var blankLineWritten = false;
    var somethingAdded = false;

    final mainPackagesToAdd = params.main.toPackages;
    final devPackagesToAdd = params.dev.toPackages;

    final lines = yamlFile.readAsLinesSync();

    for (final line in lines) {
      final onMainDependencyNode = line.startsWith('$mainDependenciesNode:');
      final onDevDependencyNode = line.startsWith('$devDependenciesNode:');

      // found main node
      if (onMainDependencyNode) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          somethingAdded |= _add(contents, devPackagesToAdd);
        }

        insideDependenciesNode = true;
        insideDevDependenciesNode = false;
      }

      // found dev node
      else if (onDevDependencyNode) {
        // maybe we were inside main node previously
        if (insideDependenciesNode) {
          somethingAdded |= _add(contents, mainPackagesToAdd);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = true;
      }

      // found some other node
      else if (rootNodeExp.hasMatch(line)) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          somethingAdded |= _add(contents, devPackagesToAdd);
        }
        // maybe we were inside main node previously
        else if (insideDependenciesNode) {
          somethingAdded |= _add(contents, mainPackagesToAdd);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      // clean extra new lines in affected nodes
      if ((insideDependenciesNode && mainPackagesToAdd.isNotEmpty) ||
          (insideDevDependenciesNode && devPackagesToAdd.isNotEmpty)) {
        if (line.trim().isEmpty) {
          if (blankLineWritten) {
            continue;
          } else {
            blankLineWritten = true;
          }
        } else {
          blankLineWritten = false;
        }
      }

      contents.writeln(line);
    }

    // no other unrelated node was found, ensure to finish deps adding
    if (insideDevDependenciesNode) {
      somethingAdded |= _add(contents, devPackagesToAdd);
    } else if (insideDependenciesNode) {
      somethingAdded |= _add(contents, mainPackagesToAdd);
    }

    // something was added
    if (somethingAdded) {
      // and we are still inside main or dev node
      if (insideDependenciesNode || insideDevDependenciesNode) {
        // ensuring no extra eof new lines are left
        yamlFile.writeAsStringSync('$contents'.trimRight().newLine);
      } else {
        yamlFile.writeAsStringSync('$contents');
      }
    }
    return somethingAdded;
  }

  static bool _add(StringBuffer contents, Set<Package> packages) {
    if (packages.isNotEmpty) {
      for (final package in packages) {
        contents.writeln(package.pubspecEntry);
      }
      contents.writeln();
      return true;
    }
    return false;
  }
}

extension on Set<String> {
  Set<Package> get toPackages => map((dep) => dep.toPackage).unmodifiable;
}
