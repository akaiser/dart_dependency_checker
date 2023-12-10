import 'dart:io' show exit;

import 'package:dart_dependency_checker/dart_dependency_checker.dart' show run;

void main(List<String> args) => exit(run(args).code);
