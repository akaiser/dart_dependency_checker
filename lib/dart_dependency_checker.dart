/// A utility package for checking dependencies within Dart/Flutter packages.
///
/// ## Usage
///
/// <hr />
///
/// ### By installing this package
///
/// Example of using the [DepsUnusedChecker] class as "mode" via arguments.
///
/// Install:
/// ```bash
/// dart pub global activate dart_dependency_checker
/// ```
///
/// Run:
/// ```bash
/// dart_dependency_checker deps-unused -p /some/package --dev-ignores lints,build_runner
/// ```
///
/// ### By depending on this package
///
/// Example of using the [DepsUnusedChecker] class.
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
///       devIgnores: {'lints', 'build_runner'},
///     ),
///   );
///
///   try {
///     print('${checker.check()}');
///   } on PubspecNotFoundError catch (e) {
///     print(e.message);
///   }
/// }
/// ```
library dart_dependency_checker;

import 'dart:io' show exit;

import 'package:dart_dependency_checker/src/runner.dart' show run;

export 'src/_exports.dart';
export 'src/deps_unused/_exports.dart';

/// Starts this utility execution.
void main(List<String> args) => exit(run(args));
