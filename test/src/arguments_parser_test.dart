import 'package:dart_dependency_checker/src/arguments_error.dart';
import 'package:dart_dependency_checker/src/arguments_parser.dart';
import 'package:dart_dependency_checker/src/arguments_result.dart';
import 'package:dart_dependency_checker/src/checker_mode.dart';
import 'package:test/test.dart';

void main() {
  test(
      'throws a $ArgumentsError with missing mode message '
      'when no modes has been provided', () {
    expect(
      () => ArgumentsParser.parse(const []),
      throwsA(
        isA<ArgumentsError>().having(
          (e) => e.message,
          'message',
          'One of mode type is required: dep-origin, deps-unused, transitive-use',
        ),
      ),
    );
  });

  test(
      'throws a $ArgumentsError with option not found message '
      'when unknown option has been provided', () {
    expect(
      () => ArgumentsParser.parse(const ['deps-unused', '--unknown']),
      throwsA(
        isA<ArgumentsError>().having(
          (e) => e.message,
          'message',
          'Could not find an option named "unknown".',
        ),
      ),
    );
  });

  test('when no path has been provided then current will be set', () {
    expect(
      ArgumentsParser.parse(const ['deps-unused']).path,
      endsWith('/dart_dependency_checker'),
    );
  });

  test('maps to $ArgumentsResult correctly', () {
    const path = 'some/path';

    final result = ArgumentsParser.parse(
      const [
        'deps-unused',
        '-p',
        path,
        '--dev-ignores',
        'lints,test',
        '--main-ignores',
        'meta',
      ],
    );

    expect(result.mode, CheckerMode.depsUnused);
    expect(result.path, path);
    expect(result.devIgnores, const {'lints', 'test'});
    expect(result.mainIgnores, const {'meta'});
  });
}
