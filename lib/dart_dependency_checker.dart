/// A utility package for checking dependencies within Dart/Flutter packages.
/// This utilities can be used directly by depending on this package or through
/// a command-line [dart_dependency_checker_cli](https://pub.dev/packages/dart_dependency_checker_cli) wrapper.
///
/// ## Usage
///
/// Install:
/// ```bash
/// dart pub add dart_dependency_checker
/// ```
///
/// Use:
/// ```dart
/// import 'package:dart_dependency_checker/dart_dependency_checker.dart';
///
/// void main() {
///   const depsUnusedChecker = DepsUnusedChecker(
///     DepsUnusedParams(
///       path: '.',
///       mainIgnores: {'meta'},
///       devIgnores: {'build_runner'},
///       fix: true, // Danger zone! Use with caution.
///     ),
///   );
///
///   const transitiveUseChecker = TransitiveUseChecker(
///     TransitiveUseParams(
///       path: '.',
///       mainIgnores: {},
///       devIgnores: {'args', 'convert'},
///     ),
///   );
///
///   try {
///     print(depsUnusedChecker.check());
///     print(transitiveUseChecker.check());
///   } on CheckerError catch (e) {
///     print(e.message);
///   }
/// }
/// ```
library;

export 'src/_exports.dart';
export 'src/deps_unused/_exports.dart';
export 'src/deps_used/_exports.dart';
export 'src/transitive_use/_exports.dart';
