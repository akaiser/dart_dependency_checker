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

  // Blindly adds main and dev dependencies to a pubspec.yaml file (without consulting dart pub add).
  const depsAddPerformer = DepsAddPerformer(
    DepsAddParams(
      path: '.',
      // Example usage
      main: {
        // 'flutter: sdk=flutter',
        // 'equatable: ^2.0.7',
        // 'yaml: 3.1.3',
        // 'some_path_source: path=../some_path_dependency',
        // 'yaansi: git=https://github.com/akaiser/yaansi.git',
      },
      // Example usage
      dev: {
        // 'flutter_test: sdk=flutter',
        // 'test: ^1.25.0',
        // 'build_runner: 2.4.15',
      },
    ),
  );

  // Sorts main and dev dependencies in a pubspec.yaml file.
  const depsSortPerformer = DepsSortPerformer(DepsSortParams(path: '.'));

  try {
    print(depsUsedChecker.perform());
    print(depsUnusedChecker.perform());
    print(transitiveUseChecker.perform());
    print(depsAddPerformer.perform());
    print(depsSortPerformer.perform());
  } on PerformerError catch (e) {
    print(e.message);
  }
}
