import 'package:dart_dependency_checker/src/deps_add/deps_add_params.dart';
import 'package:dart_dependency_checker/src/performer_error.dart';

final _sourcePatterns = <RegExp>[
  RegExp(r'^\s*path\s*=\s*\S+\s*$'),
  RegExp(r'^\s*sdk\s*=\s*\S+\s*$'),
  RegExp(r'^\s*git\s*=\s*\S+(?:\s*;\s*(?:ref|path)\s*=\s*\S+){0,2}\s*$'),
];

/// Extension on [DepsAddParams] to validate the format of dependencies.
extension DepsAddParamsExt on DepsAddParams {
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
