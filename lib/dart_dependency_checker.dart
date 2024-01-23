/// A utility package for checking dependencies within Dart/Flutter packages.
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
///   const checker = DepsUnusedChecker(
///     DepsUnusedParams(
///       path: './',
///       devIgnores: {'build_runner'},
///       mainIgnores: {'meta'},
///     ),
///   );
///
///   try {
///     print('${checker.check()}');
///   } on CheckerError catch (e) {
///     print(e.message);
///   }
/// }
/// ```
library dart_dependency_checker;

export 'src/_exports.dart';
export 'src/deps_unused/_exports.dart';
