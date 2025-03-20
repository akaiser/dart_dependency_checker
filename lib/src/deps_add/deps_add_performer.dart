import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/deps_add/model/package.dart';
import 'package:dart_dependency_checker/src/deps_add/model/source_type.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';

final _rootNodeExp = RegExp(r'^\w+:');

/// Blindly adds main and dev dependencies to a pubspec.yaml file
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

    var mainDepsToAdd = params.main.toPackages;
    var devDepsToAdd = params.dev.toPackages;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      final onMainDependencyNode = line.startsWith('$_dependenciesNode:');
      final onDevDependencyNode = line.startsWith('$_devDependenciesNode:');

      // found main node
      if (onMainDependencyNode) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          somethingAdded |= _add(contents, devDepsToAdd);
        }

        insideDependenciesNode = true;
        insideDevDependenciesNode = false;
      }

      // found dev node
      else if (onDevDependencyNode) {
        // maybe we were inside main node previously
        if (insideDependenciesNode) {
          somethingAdded |= _add(contents, mainDepsToAdd);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = true;
      }

      // found some other node
      else if (_rootNodeExp.hasMatch(line)) {
        // maybe we were inside dev node previously
        if (insideDevDependenciesNode) {
          somethingAdded |= _add(contents, devDepsToAdd);
        }
        // maybe we were inside main node previously
        else if (insideDependenciesNode) {
          somethingAdded |= _add(contents, mainDepsToAdd);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      // clean extra new lines in affected nodes
      if ((insideDependenciesNode && mainDepsToAdd.isNotEmpty) ||
          (insideDevDependenciesNode && devDepsToAdd.isNotEmpty)) {
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

      // Places SDK deps on top
      if (onMainDependencyNode) {
        final sdkDeps = mainDepsToAdd.sdkDeps;
        if (sdkDeps.isNotEmpty) {
          somethingAdded |= _add(contents, sdkDeps, false);
          mainDepsToAdd = mainDepsToAdd.difference(sdkDeps);
        }
      } else if (onDevDependencyNode) {
        final sdkDeps = devDepsToAdd.sdkDeps;
        if (sdkDeps.isNotEmpty) {
          somethingAdded |= _add(contents, sdkDeps, false);
          devDepsToAdd = devDepsToAdd.difference(sdkDeps);
        }
      }
    }

    // no other unrelated node was found, ensure to finish deps adding
    if (insideDevDependenciesNode) {
      somethingAdded |= _add(contents, devDepsToAdd);
    } else if (insideDependenciesNode) {
      somethingAdded |= _add(contents, mainDepsToAdd);
    }

    // something was added
    if (somethingAdded) {
      // and we are still inside main or dev node
      if (insideDependenciesNode || insideDevDependenciesNode) {
        // ensuring no extra eof new lines are left
        file.writeAsStringSync('$contents'.trimRight().newLine);
      } else {
        file.writeAsStringSync('$contents');
      }
    }
    return somethingAdded;
  }

  bool _add(
    StringBuffer contents,
    Set<Package> packages, [
    bool writeNewLine = true,
  ]) {
    if (packages.isNotEmpty) {
      for (final package in packages) {
        contents.write(package.pubspecEntry);
      }
      if (writeNewLine) {
        contents.writeln();
      }
      return true;
    }
    return false;
  }
}

extension on Set<String> {
  Set<Package> get toPackages => map((dep) => dep.toPackage).toSet();
}

extension on Set<Package> {
  Set<Package> get sdkDeps => where((dep) => dep.type.isSdk).toSet();
}
