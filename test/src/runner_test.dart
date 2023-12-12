import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';
import 'package:dart_dependency_checker/src/runner.dart';
import 'package:test/test.dart';

void main() {
  late _FakeLogger logger;

  setUp(() => logger = _FakeLogger());

  test(
      'providing no mode '
      'result in exit code 1 and proper stderr message', () {
    final result = run(const [], logger);

    expect(result, const ExitCode(1));
    expect(
      logger.stderrMessage,
      'One of mode type is required: dep-origin, deps-unused, transitive-use',
    );
  });

  test(
      'providing invalid path '
      'result in exit code 2 and proper stderr message', () {
    final result = run(const ['deps-unused', '-pinvalid_path'], logger);

    expect(result, const ExitCode(2));
    expect(logger.stderrMessage, 'Invalid pubspec.yml file path: invalid_path');
  });

  // TODO(albert): finish this...
}

class _FakeLogger implements Logger {
  late String stderrMessage, stdoutMessage;

  @override
  void warn(String message) => stderrMessage = message;

  @override
  void log(String message) => stdoutMessage = message;
}