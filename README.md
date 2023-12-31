# dart_dependency_checker

A utility package for checking dependencies within Dart/Flutter packages.

## Usage

<hr />

### By installing this package

Example of using the `DepsUnusedChecker` class as "mode" via arguments.

Install:
```bash
dart pub global activate dart_dependency_checker
```

Run:
```bash
ddc deps-unused -p /some/package --dev-ignores lints,build_runner
```

Or even:
```
# With instant fix
ddc deps-unused -p /some/package --fix

# In a wild mono repo environment
melos exec -c1 -- ddc deps-unused

# Run everywhere
for d in */ ; do (cd $d && ddc deps-unused); done;
```

### By depending on this package

Example of using the `DepsUnusedChecker` class.

Install:
```bash
dart pub add dart_dependency_checker
```

Use:
```dart
import 'package:dart_dependency_checker/dart_dependency_checker.dart';

void main() {
  const checker = DepsUnusedChecker(
    DepsUnusedParams(
      path: './',
      devIgnores: {'lints', 'build_runner'},
    ),
  );

  try {
    print('${checker.check()}');
  } on CheckerError catch (e) {
    print(e.message);
  }
}
 ```

## Current Todos

- Arguments and messaging needs to be improved.
- All features to be properly documented.

## Future roadmap

- Mode `dep-origin`: Utilize `dart pub deps -s compact --no-dev` to extract the origin of a direct/transitive dependency.
- Mode `transitive-use`: Direct use of undeclared/transitive dependencies.

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
