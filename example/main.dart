import 'package:dart_dependency_checker/dart_dependency_checker.dart';

void main() {
  // Checks used dependencies via imports only.
  const depsUsedChecker = DepsUsedChecker(
    DepsUsedParams(
      path: '.',
      mainIgnores: {'equatable'},
      devIgnores: {'test'},
    ),
  );

  // Checks via pubspec.yaml declared but unused dependencies.
  const depsUnusedChecker = DepsUnusedChecker(
    DepsUnusedParams(
      path: '.',
      mainIgnores: {'meta'},
      devIgnores: {'build_runner'},
      fix: false, // Danger zone! Use with caution.
    ),
  );

  // Checks direct use of pubspec.yaml undeclared aka. transitive dependencies.
  const transitiveUseChecker = TransitiveUseChecker(
    TransitiveUseParams(
      path: '.',
      mainIgnores: {},
      devIgnores: {'args', 'convert'},
    ),
  );

  try {
    print(depsUsedChecker.check());
    print(depsUnusedChecker.check());
    print(transitiveUseChecker.check());
  } on CheckerError catch (e) {
    print(e.message);
  }
}
