## Checks unused dependencies within dart packages.

### Limitations:

- Only works with package style imports (use `always_use_package_imports` in your projects).

### Todos:

- Error/file handling needs to be improved.
- Messaging and exit handling needs to be improved.
- Implement `dev_dependencies` vs. `/test` checking.
- Packages in `dev_dependencies` that already exist in `dependencies` checking.
- Tests...

### Usage:

```
# Install
dart pub global activate -sgit https://github.com/akaiser/dart_dependency_checker.git

# Use
cd /some/package/root/
dart_dependency_checker

# Or
dart_dependency_checker /some/package/root

# In a wild mono repo environment
melos exec -c1 -- dart_dependency_checker

# Or
for d in */ ; do (cd $d && dart_dependency_checker); done;
```
