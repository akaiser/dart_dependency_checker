import 'dart:io' as io show stdout, stderr;

const logPrefix = 'DDC: ';

class Logger {
  const Logger();

  void stdout(String message) => io.stdout.writeln('$logPrefix$message');

  void stderr(String message) => io.stderr.writeln('$logPrefix$message');
}
