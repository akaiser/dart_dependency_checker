import 'dart:io';

import 'package:dart_dependency_checker/src/util/file_ext.dart';

extension StringExt on String {
  File get file => .new(this);

  String get read => file.read;

  String get newLine => this + Platform.lineTerminator;
}
