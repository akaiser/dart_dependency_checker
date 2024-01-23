import 'package:dart_dependency_checker/dart_dependency_checker.dart';

void main() {
  const checker = DepsUnusedChecker(
    DepsUnusedParams(
      path: './',
      devIgnores: {'build_runner'},
      mainIgnores: {'meta'},
    ),
  );

  try {
    print('${checker.check()}');
  } on CheckerError catch (e) {
    print(e.message);
  }
}
