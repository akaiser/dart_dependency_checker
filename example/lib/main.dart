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
  } on AppError catch (e) {
    print(e.message);
  }
}
