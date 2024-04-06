import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/dart_files.dart';
import 'package:test/test.dart';

import '../_paths.dart';

void main() {
  group('from', () {
    group('for $noSourcesDirsPath', () {
      test('resolves lib files', () {
        expect(
          DartFiles.from(noSourcesDirsPath, DependencyType.mainDependencies),
          isEmpty,
        );
      });

      test('resolves test files', () {
        expect(
          DartFiles.from(noSourcesDirsPath, DependencyType.devDependencies),
          isEmpty,
        );
      });
    });
  });

  group('for $allSourcesDirsMultiPath', () {
    test('resolves lib files', () {
      final files = DartFiles.from(
        allSourcesDirsMultiPath,
        DependencyType.mainDependencies,
      );

      expect(
        files.map((file) => file.path),
        const {
          '$allSourcesDirsMultiPath/lib/main.dart',
          '$allSourcesDirsMultiPath/lib/another_main.dart',
        },
      );
    });

    test('resolves test files', () {
      final files = DartFiles.from(
        allSourcesDirsMultiPath,
        DependencyType.devDependencies,
      );

      expect(
        files.map((file) => file.path),
        const {
          '$allSourcesDirsMultiPath/test/test.dart',
          '$allSourcesDirsMultiPath/test/another_test.dart',
          '$allSourcesDirsMultiPath/integration_test/test.dart',
          '$allSourcesDirsMultiPath/integration_test/another_test.dart',
        },
      );
    });
  });
}
