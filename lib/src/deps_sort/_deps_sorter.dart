import 'dart:io';

import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_utils.dart';
import 'package:equatable/equatable.dart';

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
    final contents = StringBuffer();

    var insideDependenciesNode = false;
    var insideDevDependenciesNode = false;

    final mainPackages = <_Package>{};
    final devPackages = <_Package>{};
    final notHostedPackageTracker = _NotHostedPackageTracker();

    final lines = yamlFile.readAsLinesSync();

    for (final line in lines) {
      final onMainDependencyNode = line.startsWith('$mainDependenciesNode:');
      final onDevDependencyNode = line.startsWith('$devDependenciesNode:');

      // found main node
      if (onMainDependencyNode) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          _add(contents, devPackages, notHostedPackageTracker);
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
          _add(contents, mainPackages, notHostedPackageTracker);
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
          _add(contents, devPackages, notHostedPackageTracker);
        } else if (insideDependenciesNode) {
          _add(contents, mainPackages, notHostedPackageTracker);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      // time to parse dependencies
      if (insideDependenciesNode || insideDevDependenciesNode) {
        final target = insideDependenciesNode ? mainPackages : devPackages;
        _parseAndPopulate(line, target, notHostedPackageTracker);
        continue;
      }

      contents.writeln(line);
    }

    // no other unrelated node was found, ensure to finish deps adding
    if (insideDevDependenciesNode) {
      _add(contents, devPackages, notHostedPackageTracker);
    } else if (insideDependenciesNode) {
      _add(contents, mainPackages, notHostedPackageTracker);
    }

    final shouldHaveChanges = mainPackages.isNotEmpty || devPackages.isNotEmpty;

    if (shouldHaveChanges) {
      // and we are still inside main or dev node
      if (insideDependenciesNode || insideDevDependenciesNode) {
        // ensuring no extra eof new lines are left
        yamlFile.writeAsStringSync('$contents'.trimRight().newLine);
      } else {
        yamlFile.writeAsStringSync('$contents');
      }
    }

    return shouldHaveChanges;
  }

  static void _parseAndPopulate(
    String line,
    Set<_Package> packages,
    _NotHostedPackageTracker notHostedPackageTracker,
  ) {
    if (leafNodeExp.hasMatch(line)) {
      final split = line.trim().split(':');
      final name = split[0].trim();
      final version = split[1].trim();

      if (version.isNotEmpty && !depLocationNodeExp.hasMatch(line)) {
        if (notHostedPackageTracker.isValid) {
          packages.add(
            _Package(
              name: notHostedPackageTracker.packageNameUnderProcess,
              location: notHostedPackageTracker.packageLocation,
            ),
          );
        }
        notHostedPackageTracker.reset();

        packages.add(_Package(name: name, version: version));
      } else {
        if (version.isEmpty && !depLocationNodeExp.hasMatch(line)) {
          if (notHostedPackageTracker.isValid) {
            packages.add(
              _Package(
                name: notHostedPackageTracker.packageNameUnderProcess,
                location: notHostedPackageTracker.packageLocation,
              ),
            );
          }

          notHostedPackageTracker
            ..reset()
            ..packageNameUnderProcess = name;
        } else {
          notHostedPackageTracker.packageLocation += line.newLine;
        }
      }
    }
  }

  static void _add(
    StringBuffer contents,
    Set<_Package> packages,
    _NotHostedPackageTracker notHostedPackageTracker,
  ) {
    // ensure remaining not hosted package is added
    if (notHostedPackageTracker.isValid) {
      packages.add(
        _Package(
          name: notHostedPackageTracker.packageNameUnderProcess,
          location: notHostedPackageTracker.packageLocation,
        ),
      );

      // not really needed, but just in case
      notHostedPackageTracker.reset();
    }

    if (packages.isNotEmpty) {
      final sortedPackages = packages.sort().unmodifiable;

      final sdkPackages = sortedPackages.where((p) => p.hasSdkSource);
      final hostedPackages = sortedPackages.where((p) => p.isHosted);
      final rest = sortedPackages.where((p) => !p.isHosted && !p.hasSdkSource);

      _addSection(contents, sdkPackages);
      _addSection(contents, hostedPackages);
      _addSection(contents, rest);
    }
  }

  static void _addSection(StringBuffer contents, Iterable<_Package> packages) {
    if (packages.isNotEmpty) {
      for (final package in packages) {
        contents.write(package.pubspecEntry);
      }
      contents.writeln();
    }
  }
}

class _Package extends Equatable implements Comparable<_Package> {
  _Package({
    required this.name,
    this.version,
    this.location,
  })  : isHosted = version != null,
        hasSdkSource = location?.contains('sdk:') == true;

  final String name;
  final String? version;
  final String? location;

  // helper fields
  final bool isHosted;
  final bool hasSdkSource;

  String get pubspecEntry =>
      isHosted ? '  $name: $version'.newLine : '${'  $name:'.newLine}$location';

  @override
  int compareTo(_Package other) => name.compareTo(other.name);

  @override
  List<Object?> get props => [name, version, location];
}

class _NotHostedPackageTracker {
  var packageNameUnderProcess = '';
  var packageLocation = '';

  void reset() {
    packageNameUnderProcess = '';
    packageLocation = '';
  }

  bool get isValid =>
      packageNameUnderProcess.isNotEmpty && packageLocation.isNotEmpty;

  @override
  String toString() => '{$packageNameUnderProcess, $packageLocation}';
}
