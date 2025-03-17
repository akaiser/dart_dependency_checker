# dart_dependency_checker

A utility package for checking dependencies within Dart/Flutter packages. This utilities can be used directly by
depending on this package or through a command-line
[dart_dependency_checker_cli](https://pub.dev/packages/dart_dependency_checker_cli) wrapper.

## Usage

Install:

```bash
dart pub add dart_dependency_checker
```

Use:

```dart
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

  // Adds main and dev dependencies to a pubspec.yaml file (without consulting dart pub add).
  const depsAddPerformer = DepsAddPerformer(
    DepsAddParams(
      path: '.',
      // Example usage
      main: {
        // 'equatable: ^2.0.7',
        // 'yaml: 3.1.3',
        // 'some_path_source: path=../some_path_dependency',
        // 'some_git_source: git=https://github.com/munificent/kittens.git',
      },
      // Example usage
      dev: {
        // 'test: ^1.16.0',
        // 'build_runner: 2.4.15',
      },
    ),
  );

  try {
    print(depsUsedChecker.check());
    print(depsUnusedChecker.check());
    print(transitiveUseChecker.check());
    print(depsAddPerformer.perform());
  } on CheckerError catch (e) {
    print(e.message);
  }
}
 ```

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
