import 'dart:io';

import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

void main() {
  group('newLine', () {
    test('adds new line', () {
      expect('test'.newLine, 'test${Platform.lineTerminator}');
    });
  });
}
