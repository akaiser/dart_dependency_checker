## dart_dependency_checker

Checks declared but unused dependencies within Dart/Flutter packages.

## Current Todos

- Arguments and messaging needs to be improved.
- Tests...

## Usage

```
# Install
dart pub global activate dart_dependency_checker

# Use
dart_dependency_checker deps-unused

# Or
dart_dependency_checker deps-unused -p /some/package/root

# Or
dart_dependency_checker deps-unused -p /some/package/root --dev-ignores lints,build_runner,json_serializable

# In a wild mono repo environment
melos exec -c1 -- dart_dependency_checker deps-unused

# Or
for d in */ ; do (cd $d && dart_dependency_checker deps-unused); done;
```

## Future roadmap

- Mode `dep-origin`: Utilize `dart pub deps -s compact --no-dev` to extract the origin of a direct/transitive dependency.
- Mode `transitive-use`: Direct use of undeclared/transitive dependencies.

## License

See the [LICENSE](LICENSE) file.

## Version history

See the [CHANGELOG.md](CHANGELOG.md) file.
