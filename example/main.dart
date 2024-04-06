import 'package:dart_dependency_checker/dart_dependency_checker.dart';

void main() {
  const depsUnusedChecker = DepsUnusedChecker(
    DepsUnusedParams(
      path: '.',
      mainIgnores: {'meta'},
      devIgnores: {'build_runner'},
    ),
  );

  const transitiveUseChecker = TransitiveUseChecker(
    TransitiveUseParams(
      path: '.',
      mainIgnores: {},
      devIgnores: {'args', 'convert'},
    ),
  );

  try {
    print(depsUnusedChecker.check());
    print(transitiveUseChecker.check());
  } on CheckerError catch (e) {
    print(e.message);
  }
}
