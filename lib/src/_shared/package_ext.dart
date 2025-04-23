import 'package:dart_dependency_checker/src/_shared/package.dart';
import 'package:dart_dependency_checker/src/util/iterable_ext.dart';
import 'package:dart_dependency_checker/src/util/string_ext.dart';

extension StringExt on String {
  Package get toPackage {
    final normalized = replaceAll(' ', '');
    final colonIndex = normalized.indexOf(':');

    final name =
        colonIndex != -1 ? normalized.substring(0, colonIndex) : normalized;
    final sourcePart =
        colonIndex != -1 ? normalized.substring(colonIndex + 1) : '';

    if (sourcePart.startsWith('path=')) {
      return PathPackage(name, sourcePart.substring(5));
    }

    if (sourcePart.startsWith('sdk=')) {
      return SdkPackage(name, sourcePart.substring(4));
    }

    if (sourcePart.startsWith('git=')) {
      final rest = sourcePart.substring(4);
      final parts = rest.split(';').map((p) => p).unmodifiable;
      String? ref;
      String? path;

      for (final part in parts.skip(1)) {
        if (part.startsWith('ref=')) {
          ref = part.substring(4);
        } else if (part.startsWith('path=')) {
          path = part.substring(5);
        }
      }

      return GitPackage(name, parts.first, ref: ref, path: path);
    }

    return HostedPackage(name, sourcePart);
  }
}

extension PubspecEntry on Package {
  String get pubspecEntry {
    switch (this) {
      case HostedPackage(:final name, :final version):
        return '  $name: $version';

      case PathPackage(:final name, :final path):
        return '  $name${':'.newLine}    path: $path';

      case SdkPackage(:final name, :final sdk):
        return '  $name${':'.newLine}    sdk: $sdk';

      case GitPackage(:final name, :final url, :final ref, :final path):
        if (ref == null && path == null) {
          return '  $name${':'.newLine}    git: $url';
        }

        final buffer = StringBuffer()
          ..writeln('  $name:')
          ..writeln('    git:')
          ..write('      url: $url');

        if (ref != null) {
          buffer
            ..writeln()
            ..write('      ref: $ref');
        }
        if (path != null) {
          buffer
            ..writeln()
            ..write('      path: $path');
        }

        return buffer.toString();
    }
  }
}
