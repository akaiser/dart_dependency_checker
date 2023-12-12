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
