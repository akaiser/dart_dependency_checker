import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';

final _rootNodeExp = RegExp(r'^\w+:');

/// Adds main and dev dependencies to a pubspec.yaml file
/// (without consulting dart pub add).
///
/// In a perfect world, for simplicity:
/// - Doesn't care if the dependency is already in the file.
/// - Won't add a dependency if the main/dev node is missing.
/// - Supports sources with single level of nesting.
///
/// Returns `true` if at least one dependency was added.
class DepsAddPerformer extends Performer<DepsAddParams, bool> {
  const DepsAddPerformer(super.params);

  static final _dependenciesNode = DependencyType.mainDependencies.yamlNode;
  static final _devDependenciesNode = DependencyType.devDependencies.yamlNode;

  @override
  bool perform() {
    final file = PubspecYamlFinder.from(params.path);

    final contents = StringBuffer();

    var insideDependenciesNode = false;
    var insideDevDependenciesNode = false;
    var blankLineWritten = false;
    var somethingAdded = false;

    final lines = file.readAsLinesSync();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.startsWith('$_dependenciesNode:')) {
        if (insideDevDependenciesNode) {
          somethingAdded = _add(contents, params.dev) || somethingAdded;
        }

        insideDependenciesNode = true;
        insideDevDependenciesNode = false;
      } else if (line.startsWith('$_devDependenciesNode:')) {
        if (insideDependenciesNode) {
          somethingAdded = _add(contents, params.main) || somethingAdded;
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = true;
      } else if (_rootNodeExp.hasMatch(line) &&
          (insideDependenciesNode || insideDevDependenciesNode)) {
        if (insideDevDependenciesNode) {
          somethingAdded = _add(contents, params.dev) || somethingAdded;
        }
        if (insideDependenciesNode) {
          somethingAdded = _add(contents, params.main) || somethingAdded;
        }
        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      // clean extra new lines in affected nodes
      if ((insideDependenciesNode && params.main.isNotEmpty) ||
          (insideDevDependenciesNode && params.dev.isNotEmpty)) {
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

    // no other unrelated node was found, ensure to finish dep adding
    if (insideDevDependenciesNode) {
      somethingAdded = _add(contents, params.dev) || somethingAdded;
    }
    if (insideDependenciesNode) {
      somethingAdded = _add(contents, params.main) || somethingAdded;
    }

    // something was added, ensure no extra eof new lines
    if ((insideDependenciesNode && params.main.isNotEmpty) ||
        (insideDevDependenciesNode && params.dev.isNotEmpty)) {
      file.writeAsStringSync('$contents'.trimRight().newLine);
    } else {
      file.writeAsStringSync('$contents');
    }

    return somethingAdded;
  }

  bool _add(StringBuffer contents, Set<String> dependencies) {
    var somethingAdded = false;

    for (final dependency in dependencies) {
      final parts = dependency.split(':');

      final dependencyName = parts[0].trim();
      final dependencyValue = parts[1].trim();
      final dependencySource = parts.length > 2
          ? '$dependencyValue:${parts[2].trim()}'
          : dependencyValue;

      final sourceParts = dependencySource.split('=');

      if (sourceParts.length == 2) {
        final sourceName = sourceParts[0].trim();
        final sourceValue = sourceParts[1].trim();

        contents.writeln('  $dependencyName:');
        contents.writeln('    $sourceName: $sourceValue');
      } else {
        contents.writeln('  $dependencyName: $dependencySource');
      }

      somethingAdded = true;
    }

    if (somethingAdded) {
      contents.writeln();
    }

    return somethingAdded;
  }
}

extension on String {
  String get newLine => this + Platform.lineTerminator;
}
