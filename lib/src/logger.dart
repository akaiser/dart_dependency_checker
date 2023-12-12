import 'dart:io' as io show stdout, stderr;

class Logger {
  const Logger();

  void log(String message) => io.stdout.writeln('\x1B[32m$message\x1B[0m');

  void warn(String message) => io.stderr.writeln('\x1B[93m$message\x1B[0m');
}
