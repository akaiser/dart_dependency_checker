import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/runner.dart';
import 'package:test/test.dart';

import '_fake_logger.dart';

void main() {
  late FakeLogger logger;

  setUp(() => logger = FakeLogger());

  test(
      'providing no mode '
      'result in exit code 1 and proper error message', () {
    final result = run(const [], logger);

    expect(result, const ExitCode(1));
    expect(logger.infoMessage, isEmpty);
    expect(logger.warnMessage, isEmpty);
    expect(logger.errorMessage, '''
One of mode type is required: dep-origin, deps-unused, transitive-use
''');
  });

  test(
      'providing invalid path '
      'result in exit code 2 and proper error message', () {
    final result = run(const ['deps-unused', '-p', 'invalid_path'], logger);

    expect(result, const ExitCode(2));
    expect(logger.infoMessage, isEmpty);
    expect(logger.warnMessage, isEmpty);
    expect(logger.errorMessage, '''
Invalid pubspec.yml file path: invalid_path
''');
  });

  test('bla', () {
    final result = run(
      const [
        'deps-unused',
        '-p',
        'test/resources/deps_unused/no_dependencies',
      ],
      logger,
    );

    expect(result, const ExitCode(0));
    expect(logger.infoMessage, isNotEmpty);
    expect(logger.warnMessage, isEmpty);
    expect(logger.errorMessage, isEmpty);
  });
}
