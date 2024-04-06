import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';

final _importPackageExp = RegExp(r':(.*?)/');

abstract final class DartFiles {
  static Set<File> from(String path, DependencyType dependencyType) =>
      dependencyType.sourceDirectories.fold(
        const <File>{},
        (init, directory) => {...init, ..._fromPath('$path/$directory')},
      );

  static Set<String> packages(File file) => file
      .readAsLinesSync()
      .where((line) => line.startsWith('import \'package:'))
      .map((import) => _importPackageExp.firstMatch(import)?[1])
      .nonNulls
      .toSet();

  static Set<File> _fromPath(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory
          .listSync(recursive: true, followLinks: false)
          .where((file) => file is File && file.path.endsWith('.dart'))
          .map((file) => file as File)
          .toSet();
    }
    return const {};
  }
}
