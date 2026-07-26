import 'dart:io';

extension FileExt on File {
  String get read => readAsStringSync();
}
