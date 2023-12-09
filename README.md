WIP...

Checks unused imports withing dart packages.

Limitations:

- Only works with package style imports.

Todos:

- Error/file handling needs to improved.
- Messaging and exit handling needs to improved.
- Implement "dev_dependencies" vs. /test checking.
- Packages in "dev_dependencies" that already exist in "dependencies" checking.
- Tests...

Usage:

```
# install
dart pub global activate -sgit https://github.com/akaiser/dart_dependency_checker.git

# use
cd /some/package/root/
dart_dependency_checker

# or
dart_dependency_checker /some/package/root
```
