import 'package:dart_dependency_checker/src/performer_error.dart';

final _sourcePatterns = <RegExp>[
  RegExp(r'^\s*path\s*=\s*\S+\s*$'),
  RegExp(r'^\s*sdk\s*=\s*\S+\s*$'),
  RegExp(r'^\s*hosted\s*=\s*\S+\s*;\s*version\s*=\s*\S+\s*$'),
  RegExp(r'^\s*git\s*=\s*\S+(?:\s*;\s*(?:ref|path)\s*=\s*\S+){0,2}\s*$'),
];

/// Util to validate the format of dependencies.
extension DepsValidationExt on Set<String> {
  /// Validates provided dependencies for expected format.
  ///
  /// Throws [InvalidParamsError] if any does not comply.
  void validate() {
    if (isNotEmpty) {
      for (final dep in this) {
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
            sourcePart.startsWith('hosted') ||
            sourcePart.startsWith('git')) {
          throw InvalidParamsError(dep);
        }
      }
    }
  }
}
