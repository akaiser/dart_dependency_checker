import 'dart:io';

import 'package:dart_dependency_checker/src/dependency_type.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:path/path.dart';

const _dartFileExt = '.dart';
final _importExportPackagePattern = RegExp(
  r"^(?:import|export) 'package:(.*?)/",
);

abstract final class DartFiles {
  static Set<File> from(String path, DependencyType dependencyType) =>
      dependencyType.sourceDirectories.fold(
        const <File>{},
        (init, directory) => {...init, ..._fromPath('$path/$directory')},
      );

  static Set<String> packages(File file) => file
      .readAsLinesSync()
      .map((line) => _importExportPackagePattern.firstMatch(line)?[1])
      .nonNulls
      .unmodifiable;

  static Set<File> _fromPath(String path) {
    final directory = Directory(path);
    if (directory.existsSync()) {
      return directory
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => extension(file.path) == _dartFileExt)
          .unmodifiable;
    }
    return const {};
  }
}
