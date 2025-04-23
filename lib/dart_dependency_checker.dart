/// A utility package for checking dependencies within Dart/Flutter packages.
/// This utilities can be used directly by depending on this package or through
/// a command-line [dart_dependency_checker_cli](https://pub.dev/packages/dart_dependency_checker_cli) wrapper.
///
/// ## Usage
///
/// ### Installation
///
/// ```bash
/// dart pub add dart_dependency_checker
/// ```
///
/// ### Example:
///
/// ```dart
/// import 'package:dart_dependency_checker/dart_dependency_checker.dart';
///
/// void main() {
///   // Checks used dependencies via imports only.
///   const depsUsedChecker = DepsUsedChecker(
///     DepsUsedParams(
///       path: '.',
///       mainIgnores: {'equatable'},
///       devIgnores: {'test'},
///     ),
///   );
///
///   // Checks via pubspec.yaml declared but unused dependencies.
///   const depsUnusedChecker = DepsUnusedChecker(
///     DepsUnusedParams(
///       path: '.',
///       mainIgnores: {'meta'},
///       devIgnores: {'build_runner'},
///       fix: false, // Danger zone! Use with caution.
///     ),
///   );
///
///   // Checks direct use of pubspec.yaml undeclared aka. transitive dependencies.
///   const transitiveUseChecker = TransitiveUseChecker(
///     TransitiveUseParams(
///       path: '.',
///       mainIgnores: {},
///       devIgnores: {'args', 'convert'},
///     ),
///   );
///
///   // Blindly adds main and dev dependencies to a pubspec.yaml file (without consulting dart pub add).
///   const depsAddPerformer = DepsAddPerformer(
///     DepsAddParams(
///       path: '.',
///       // Example usage
///       main: {
///         // 'flutter: sdk=flutter',
///         // 'equatable: ^2.0.7',
///         // 'yaml: 3.1.3',
///         // 'any_where: hosted=any.where.com; version=1.1.1',
///         // 'some_path_source: path=../some_path_dependency',
///         // 'yaansi: git=https://github.com/akaiser/yaansi.git',
///         // 'some: git=https://anywhere.com/some.git; ref=some_ref; path=some/path',
///       },
///       // Example usage
///       dev: {
///         // 'flutter_test: sdk=flutter',
///         // 'test: ^1.25.0',
///         // 'build_runner: 2.4.15',
///       },
///     ),
///   );
///
///   // Sorts main and dev dependencies in a pubspec.yaml file.
///   const depsSortPerformer = DepsSortPerformer(DepsSortParams(path: '.'));
///
///   try {
///     print(depsUsedChecker.perform());
///     print(depsUnusedChecker.perform());
///     print(transitiveUseChecker.perform());
///     print(depsAddPerformer.perform());
///     print(depsSortPerformer.perform());
///   } on PerformerError catch (e) {
///     print(e.message);
///   }
/// }
/// ```
library;

export 'src/_exports.dart';
export 'src/deps_add/_exports.dart';
export 'src/deps_sort/_exports.dart';
export 'src/deps_unused/_exports.dart';
export 'src/deps_used/_exports.dart';
export 'src/transitive_use/_exports.dart';
