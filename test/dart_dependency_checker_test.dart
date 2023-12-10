import 'package:dart_dependency_checker/dart_dependency_checker.dart';
import 'package:dart_dependency_checker/src/exit_code.dart';
import 'package:dart_dependency_checker/src/logger.dart';
import 'package:test/test.dart';

void main() {
  late _FakeLogger logger;

  setUp(() => logger = _FakeLogger());

  test(
      'providing invalid path '
      'result in exit code 2 and proper stderr message', () {
    final result = run(const ['invalid_path'], logger);

    expect(result, const ExitCode(2));
    expect(logger.stderrMessage, 'Invalid pubspec.yml file path: invalid_path');
  });

  // TODO(albert): finish this...
}

class _FakeLogger implements Logger {
  late String stderrMessage, stdoutMessage;

  @override
  void stderr(String message) => stderrMessage = message;

  @override
  void stdout(String message) => stdoutMessage = message;
}
