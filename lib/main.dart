import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:dart_dependency_checker/src/check.dart';

Future<void> main(List<String> args) async {
  final console = Console();
  //final console = Console()..clearScreen();
  checkUnused(args, console);
  exit(exitCode);
}
