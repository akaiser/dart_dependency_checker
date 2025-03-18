## 0.4.3

- `DepsAddPerformer` places SDK deps on top.

## 0.4.2

- `DepsAddPerformer` returns true on change.

## 0.4.1

- `DepsAddPerformer` does a little new lines cleanup.

## 0.4.0

- Added `DepsAddPerformer` implementation.
- Breaking change: Change main interface to more generic `Performer` signature.

## 0.3.2

- `DepsUnusedChecker` guarantees valid yaml output after `fix` run.

## 0.3.1

- `DepsUsedChecker` ignores own referenced package.

## 0.3.0

- Added `DepsUsedChecker` implementation.
- Require Dart `^3.6.0`.

## 0.2.0

- Require Dart `^3.5.0`.

## 0.1.7

- `TransitiveUseChecker` ignores:
    - own referenced package.
    - provided in main but missing in dev dependencies.
- Update docs, dependencies and internals.
- Require Dart `^3.4.0`.

## 0.1.6

- Expose `BaseResults` in the lib.

## 0.1.5

- Removed `fix` property from `TransitiveUseChecker`.

## 0.1.4

- Added `TransitiveUseChecker` implementation.
- Require Dart `^3.3.0`.

## 0.1.3

- Split of dart_dependency_checker lib and cli.

## 0.1.2

- Eliminate extra blank lines after `fix` run.
- Add `.yml` file extension support.

## 0.1.1

- Add instant `fix` property for the `DepsUnusedChecker`.
- Add `mainIgnores` property for the `DepsUnusedChecker`.

## 0.1.0

- Splitting public and internal API.
- Add more documentation and tests.
- Add example project.

## 0.0.3

- Fixes issue where unused dependencies won't be reported if source directories do not exist.

## 0.0.2

- Add output colors and example.

## 0.0.1

- Initial version.
