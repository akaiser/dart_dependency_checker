import 'package:dart_dependency_checker/src/util/string_ext.dart';
import 'package:equatable/equatable.dart';

abstract class Package extends Equatable implements Comparable<Package> {
  const Package(this.name);

  final String name;

  String get pubspecEntry;

  @override
  int compareTo(Package other) => name.compareTo(other.name);
}

class SdkPackage extends Package {
  const SdkPackage(super.name, {required this.sdk});

  final String sdk;

  @override
  String get pubspecEntry => '${'  $name:'.newLine}    sdk: $sdk';

  @override
  List<Object?> get props => [name, sdk];
}

class PathPackage extends Package {
  const PathPackage(super.name, {required this.path});

  final String path;

  @override
  String get pubspecEntry => '${'  $name:'.newLine}    path: $path';

  @override
  List<Object?> get props => [name, path];
}

class HostedPackage extends Package {
  const HostedPackage(super.name, this.version, {this.hostedUrl});

  final String version;
  final String? hostedUrl;

  @override
  String get pubspecEntry => hostedUrl != null
      ? '${'  $name:'.newLine}    hosted: ${hostedUrl?.newLine}    version: $version'
      : '  $name: $version';

  @override
  List<Object?> get props => [name, version, hostedUrl];
}

class GitPackage extends Package {
  const GitPackage(super.name, {required this.url, this.path, this.ref});

  final String url;
  final String? path;
  final String? ref;

  @override
  String get pubspecEntry {
    if (path == null && ref == null) {
      return '${'  $name:'.newLine}    git: $url';
    } else {
      final buffer = StringBuffer()
        ..writeln('  $name:')
        ..writeln('    git:')
        ..write('      url: $url');

      if (path != null) {
        buffer
          ..writeln()
          ..write('      path: $path');
      }
      if (ref != null) {
        buffer
          ..writeln()
          ..write('      ref: $ref');
      }

      return buffer.toString();
    }
  }

  @override
  List<Object?> get props => [name, url, path, ref];
}
