import 'dart:io';

extension StringExt on String {
  String get newLine => this + Platform.lineTerminator;
}
