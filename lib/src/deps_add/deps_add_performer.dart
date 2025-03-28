import 'package:dart_dependency_checker/src/deps_add/_deps_adder.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';

/// Blindly adds main and dev dependencies to a pubspec.yaml file
/// (without consulting dart pub add).
///
/// For simplicity:
/// - Doesn't care if the dependency is already in the file.
/// - Doesn't care about the order of source type placement.
/// - Doesn't know anything about `dependency_overrides` node.
/// - Won't add a dependency if the main/dev node is missing.
/// - Supports sources with single level of nesting.
///
/// Returns `true` if at least one dependency was added.
class DepsAddPerformer extends Performer<DepsAddParams, bool> {
  const DepsAddPerformer(super.params);

  @override
  bool perform() => DepsAdder.add(params, YamlFileFinder.from(params.path));
}
