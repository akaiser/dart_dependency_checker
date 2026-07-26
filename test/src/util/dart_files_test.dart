import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('from', () {
    group('for $noSourcesDirsPath', () {
      test('resolves lib files', () {
        final files = DartFiles.from(noSourcesDirsPath, .mainDependencies);

        expect(files, isEmpty);
      });

      test('resolves test files', () {
        final files = DartFiles.from(noSourcesDirsPath, .devDependencies);

        expect(files, isEmpty);
      });
    });
  });

  group('packages', () {
    const path = exportImportPath;

    test('import', () {
      final packages = DartFiles.packages('$path/import.dart'.file);

      expect(packages, const {'fritz', 'jens'});
    });

    test('export', () {
      final packages = DartFiles.packages('$path/export.dart'.file);

      expect(packages, const {'franz', 'hans'});
    });

    test('export import', () {
      final packages = DartFiles.packages('$path/export_import.dart'.file);

      expect(packages, const {'export', 'import'});
    });
  });

  group('for $allSourcesDirsMultiPath', () {
    test('resolves lib files', () {
      final files = DartFiles.from(allSourcesDirsMultiPath, .mainDependencies);

      expect(files.map((file) => file.path), const {
        '$allSourcesDirsMultiPath/lib/main.dart',
        '$allSourcesDirsMultiPath/lib/another_main.dart',
      });
    });

    test('resolves test files', () {
      final files = DartFiles.from(allSourcesDirsMultiPath, .devDependencies);

      expect(files.map((file) => file.path), const {
        '$allSourcesDirsMultiPath/test/test.dart',
        '$allSourcesDirsMultiPath/test/another_test.dart',
        '$allSourcesDirsMultiPath/integration_test/test.dart',
        '$allSourcesDirsMultiPath/integration_test/another_test.dart',
      });
    });
  });
}
