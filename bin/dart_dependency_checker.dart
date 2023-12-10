import 'dart:io';

import 'package:dart_dependency_checker/dart_dependency_checker.dart' as ddc;

void main(List<String> args) => exit(ddc.run(args).code);
