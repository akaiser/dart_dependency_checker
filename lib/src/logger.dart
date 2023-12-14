import 'dart:io' show stdout, stderr;

class Logger {
  const Logger();

  void info(String message) => stdout.writeln('\x1B[32m$message\x1B[0m');

  void warn(String message) => stdout.writeln('\x1B[93m$message\x1B[0m');

  void error(String message) => stderr.writeln('\x1B[31m$message\x1B[0m');
}
