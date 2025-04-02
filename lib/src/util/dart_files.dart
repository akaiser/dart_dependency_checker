import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';

const _dartFileExt = '.dart';
const _importPackagePattern = 'import \'package:';
final _importPackageExp = RegExp(r':(.*?)/');

abstract final class DartFiles {
  static Set<File> from(String path, DependencyType dependencyType) =>
      dependencyType.sourceDirectories.fold(
        const <File>{},
        (init, directory) => {...init, ..._fromPath('$path/$directory')},
      );

  static Set<String> packages(File file) => file
      .readAsLinesSync()
      .where((line) => line.startsWith(_importPackagePattern))
      .map((import) => _importPackageExp.firstMatch(import)?[1])
      .nonNulls
      .unmodifiable;

  static Set<File> _fromPath(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith(_dartFileExt))
          .unmodifiable;
    }
    return const {};
  }
}
