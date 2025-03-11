import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/pubspec_yaml_finder.dart';

final _rootNodeExp = RegExp(r'^\w+:');

/// Adds main and dev dependencies to a pubspec.yaml file
/// (without consulting dart pub add).
///
/// In a perfect word, for simplicity:
/// - Doesn't care if the dependency is already in the file.
/// - Won't add a dependency if the main/dev node is missing.
/// - Supports sources with single level of nesting.
class DepsAddPerformer extends Performer<DepsAddParams, void> {
  const DepsAddPerformer(super.params);

  static final _dependenciesNode = DependencyType.mainDependencies.yamlNode;
  static final _devDependenciesNode = DependencyType.devDependencies.yamlNode;

  @override
  void perform() {
    final file = PubspecYamlFinder.from(params.path);

    final contents = StringBuffer();

    var insideDependenciesNode = false;
    var insideDevDependenciesNode = false;

    final lines = file.readAsLinesSync();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.startsWith('$_dependenciesNode:')) {
        if (insideDevDependenciesNode) {
          _add(contents, params.dev);
        }

        insideDependenciesNode = true;
        insideDevDependenciesNode = false;
      } else if (line.startsWith('$_devDependenciesNode:')) {
        if (insideDependenciesNode) {
          _add(contents, params.main);
        }

        insideDependenciesNode = false;
        insideDevDependenciesNode = true;
      } else if (_rootNodeExp.hasMatch(line) &&
          (insideDependenciesNode || insideDevDependenciesNode)) {
        if (insideDevDependenciesNode) {
          _add(contents, params.dev);
        }
        if (insideDependenciesNode) {
          _add(contents, params.main);
        }
        insideDependenciesNode = false;
        insideDevDependenciesNode = false;
      }

      contents.writeln(line);

      if (i == lines.length - 1) {
        if (insideDevDependenciesNode) {
          _add(contents, params.dev);
        }
        if (insideDependenciesNode) {
          _add(contents, params.main);
        }
      }
    }

    file.writeAsStringSync(contents.toString());
  }

  void _add(StringBuffer contents, Set<String> dependencies) {
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
  }
}
