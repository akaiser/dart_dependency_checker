import 'dart:io';

import 'package:dart_dependency_checker/src/util/file_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('file', () {
    test('existing', () {
      expect('$exportImportPath/import.dart'.file.existsSync(), isTrue);
    });

    test('non existing', () {
      expect('any.dart'.file.existsSync(), isFalse);
    });
  });

  group('read', () {
    test('existing', () {
      expect('$exportImportPath/import.dart'.file.read, isNotEmpty);
    });

    test('non existing', () {
      expect(
        () => 'any.dart'.file.read,
        throwsA(
          isA<PathNotFoundException>().having(
            (e) => e.message,
            'message',
            startsWith('Cannot open file'),
          ),
        ),
      );
    });
  });

  group('newLine', () {
    test('adds new line', () {
      expect('test'.newLine, 'test${Platform.lineTerminator}');
    });
  });
}
