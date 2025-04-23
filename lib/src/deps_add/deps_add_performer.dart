import 'package:dart_dependency_checker/src/deps_add/_deps_adder.dart';
import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';
import 'package:dart_dependency_checker/src/util/yaml_file_finder.dart';

final _sourcePatterns = <RegExp>[
  RegExp(r'^\s*path\s*=\s*\S+\s*$'),
  RegExp(r'^\s*sdk\s*=\s*\S+\s*$'),
  RegExp(r'^\s*git\s*=\s*\S+(?:\s*;\s*(?:ref|path)\s*=\s*\S+){0,2}\s*$'),
];

/// Blindly adds main and dev dependencies to a pubspec.yaml file
/// (without consulting dart pub add).
///
/// For simplicity:
/// - Doesn't care if the dependency is already in the file.
/// - Doesn't care about the order of source type placement.
/// - Doesn't know anything about `dependency_overrides` node.
/// - Won't add a dependency if the main/dev node is missing.
/// TODO(Albert): Allow this...
/// - Supports sources with single level of nesting.
///
/// Throws [InvalidParamsError] if any dependency in provided `params`
/// does not comply with the expected format.
/// Returns `true` if at least one dependency was added.
class DepsAddPerformer extends Performer<DepsAddParams, bool> {
  const DepsAddPerformer(super.params);

  @override
  bool perform() => DepsAdder.add(
        params..validate(),
        YamlFileFinder.from(params.path),
      );
}

extension on DepsAddParams {
  /// Validates provided `main` and `dev` dependency buckets for expected format.
  ///
  /// Throws [InvalidParamsError] if any does not comply.
  void validate() {
    _validate(main);
    _validate(dev);
  }

  void _validate(Set<String> bucket) {
    if (bucket.isNotEmpty) {
      for (final dep in bucket) {
        final trimmed = dep.trim();
        final colonIndex = trimmed.indexOf(':');

        if (colonIndex == -1) throw InvalidParamsError(dep);

        final sourcePart = trimmed.substring(colonIndex + 1).trim();
        if (sourcePart.isEmpty) {
          throw InvalidParamsError(dep);
        }

        for (final sourcePattern in _sourcePatterns) {
          if (sourcePattern.hasMatch(sourcePart)) return;
        }

        if (sourcePart.startsWith('path') ||
            sourcePart.startsWith('sdk') ||
            sourcePart.startsWith('git')) {
          throw InvalidParamsError(dep);
        }
      }
    }
  }
}
