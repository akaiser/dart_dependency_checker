import 'package:dart_dependency_checker/src/deps_sort/_deps_sorter.dart';
import 'package:dart_dependency_checker/src/deps_sort/deps_sort_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';

/// Sorts main and dev dependencies in a pubspec.yaml file.
///
/// For simplicity:
/// - Sorts packages alphabetically.
/// - Places packages by source order: sdk, hosted and rest.
/// - Will remove all comments and extra new lines.
/// - Doesn't know anything about `dependency_overrides` node.
///
/// Returns `true` on any change.
class DepsSortPerformer extends Performer<DepsSortParams, bool> {
  const DepsSortPerformer(super.params);

  @override
  bool perform() => DepsSorter.sort(YamlFileFinder.from(params.path));
}
