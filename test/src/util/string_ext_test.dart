import 'dart:io';

import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('file', () {
    test('reads existing file', () {
      expect('$exportImportPath/import.dart'.file.existsSync(), isTrue);
    });

    test('reads non existing file', () {
      expect('any.dart'.file.existsSync(), isFalse);
    });
  });

  group('newLine', () {
    test('adds new line', () {
      expect('test'.newLine, 'test${Platform.lineTerminator}');
    });
  });
}
