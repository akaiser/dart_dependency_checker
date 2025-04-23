import 'package:equatable/equatable.dart';

sealed class Package extends Equatable implements Comparable<Package> {
  const Package(this.name);

  final String name;

  @override
  int compareTo(Package other) => name.compareTo(other.name);
}

class HostedPackage extends Package {
  const HostedPackage(super.name, this.version, {this.url});

  final String version;
  final String? url;

  @override
  List<Object?> get props => [name, version, url];
}

class PathPackage extends Package {
  const PathPackage(super.name, this.path);

  final String path;

  @override
  List<Object?> get props => [name, path];
}

class SdkPackage extends Package {
  const SdkPackage(super.name, this.sdk);

  final String sdk;

  @override
  List<Object?> get props => [name, sdk];
}

class GitPackage extends Package {
  const GitPackage(super.name, {required this.url, this.ref, this.path});

  final String url;
  final String? ref;
  final String? path;

  @override
  List<Object?> get props => [name, url, ref, path];
}
